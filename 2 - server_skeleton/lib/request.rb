class Request
  attr_reader :resource, :version, :headers, :params, :method
  def initialize(request_string:)
    @method, @resource, @version, @headers, @params = parse_request_line(request_string)
  end

  private 
  def parse_request_line(req)
    lines = req.split("\n")
    if lines[0] == nil then
       print("bug") 
       return nil 
    end
    method, resource, version = lines[0].split()
    headers = handle_headers(lines.slice(1..lines.length))
    if method == "GET"
      params = handle_get_params(resource)
    elsif method == "POST"
      params = handle_post_params(lines[-1])
    end
    return method, resource, version, headers, params
  end
  ## Header handler
  def handle_headers(lines)
    headers = Hash.new
    lines.each do |line|
      if !line.include?(":") then return headers end
     split = line.split(": ")
     headers[split[0]] = split[1]
    end
    headers
  end

  ## GET handlers
  def handle_get_params(resource)
    paramshash = Hash.new
    fulllist = resource.split("?")[1]
    if !fulllist then return "" end
    parameters = fulllist.split("&")
    parameters.each do |param|
      split = param.split("=")
      paramshash[split[0]] = split[1].delete(" ")
    end
    paramshash
  end
  ## POST handlers
  def handle_post_params(lines)
    paramshash = Hash.new
    parameters = lines.split("&")
    parameters.each do |param|
      split = param.split("=")
      paramshash[split[0]] = split[1].delete(" ")
    end
    paramshash
  end
end

