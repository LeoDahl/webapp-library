class Request
  attr_reader :resource, :version, :headers, :params, :method
  def initialize(request_string:)
    @method, @resource, @version, @headers, @params = parse_request_line(request_string)
  end

  def get_method
    @method
  end
  def get_content_length
    @headers["Content-Length"].to_i
  end
  def get_post_params(content)
    @params = handle_params(content, "POST")
    @params
  end
  def get_resource()
    @resource
  end

  private 
  def parse_request_line(req)
    if req == nil then return end 
    attributes, *body = req.split("\n")

    method, resource, version = attributes.split()
    headers = handle_headers(body)
    if method == "GET" 
      params = handle_params(resource, "GET") 
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
      split = param.split("=")
      paramshash[split[0]] = split[1].delete(" ")
    end
    paramshash
  end

end

