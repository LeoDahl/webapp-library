class Request
  attr_reader :resource, :version, :headers, :params, :method
  def initialize(request_string:)
    @method, @resource, @version, @headers = parse_request_line(request_string)
  end

  private 
  def parse_request_line(req)
    p "req = #{req}"
    attributes, *body = req.split("\n\n")

    method, resource, version = attributes.split()
    p body
    headers = handle_headers(body)
    puts "headers: #{headers}"
    if method == "GET" then handle_get_params(resource) end
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

  def handle_params(resource, type)
    paramshash = Hash.new
    parameters = nil
    if type == "GET"
      puts "GET"
      fulllist = resource.split("?")[1]
      if !fulllist then return end
      parameters = fulllist.split("&")
    else
      puts "POST"
      parameters = resource.split("&")
    end
    parameters.each do |param|
      puts "param #{parameters}"
      split = param.split("=")
      paramshash[split[0]] = split[1].delete(" ")
    end
    paramshash
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
  def parse_params(paramline)
    paramshash = Hash.new
    parameters = resource.split("&")
    parameters.each do |param|
      split = param.split("=")
      paramshash[split[0]] = split[1].delete(" ")
    end
    paramshash
  end
end

