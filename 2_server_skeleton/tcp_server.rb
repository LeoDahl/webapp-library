require 'socket'
require 'debug'
require './lib/request.rb'
require './lib/router.rb'
require './lib/response.rb'


class HTTPServer

  def initialize(port, router, responseHandler)
    @port = port
    @router = router
    @responseHandler = responseHandler
  end

  def start
    server = TCPServer.new(@port)
    
    puts "Listening on #{@port}"

    while session = server.accept
      data = ''
      while line = session.gets and line !~ /^\s*$/
        data += line
      end
      puts "RECEIVED REQUEST"
      puts '-' * 40
      puts data
      puts '-' * 40

      request = Request.new(request_string: data)
      
      if request.method == "POST"
        content = session.gets(request.get_content_length)
        request.get_post_params(content)
        @router.handle_resource(request)
      else
      
      p "new router = #{@router}"
     # binding.break
      @router.handle_resource(request)

      resource = request.resource

      accept = request.headers["Accept"]

      content, content_type = @responseHandler.build(resource, session, accept)

      session.print "HTTP/1.1 200\r\n"
      session.print "Content-Type: #{content_type}\r\n"

      session.print ""
      session.print "\r\n"
      session.print content
      session.close
      end
      
    end
  end
end

router = Router.new()
responseHandler = Response.new()


router.add_route("GET", "/") do
  load_file = "/html/hello.html"
  responseHandler.load(load_file, "/")
end
router.add_route("GET", "/hello") do
  load_file = "/html/hello.html"
  responseHandler.load(load_file, "/hello")
end
router.add_route("GET", "/ok/:id/test") do |id| ## /ok/4/test
  #p id
  #return File.read("public/html/hello.html")
  p "hi"
  return "id was: #{id}"
  #responseHandler.load(load_file, "/ok/skibidi/test")

end
router.add_route("GET", "/ok/:id/at/:test") do |id, testthing| ## /ok/4/test
  puts "id = #{id}"
  puts "test = #{testthing}"
end
router.add_route("POST", "/") do |id|
  puts "hej"
end

p "org router #{router}"
server = HTTPServer.new(4567, router, responseHandler)
server.start

