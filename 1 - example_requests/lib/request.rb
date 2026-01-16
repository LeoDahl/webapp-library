class Request
  attr_reader :resource, :version, :headers, :params, :method
  def initialize(request_string:)
    @method, @resource, @version, @headers, @params = parse_request_line(request_string)
  end

  private 
  def parse_request_line(req)
    lines = req.split("\r\n")
    host, resource, version = lines[0].split()
    handlemethods()
  end
  def handlemethods()

  end
end

