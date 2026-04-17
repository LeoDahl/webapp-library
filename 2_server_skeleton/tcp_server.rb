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
      if data == nil
        return
      end
      #puts "RECEIVED REQUEST"
      #puts '-' * 40
      #puts data
      #puts '-' * 40

      request = Request.new(request_string: data)
      
      if request.method == "POST"
        #p "post recieved"
        content = session.gets(request.get_content_length)
        postparams = request.get_post_params(content)
        #p "postparams  = #{postparams}"
        #p "request = #{request}"
        @router.handle_post_resource(request, postparams)
      else
      
      #p "new router = #{@router}"
     # binding.break
      call = @router.handle_resource(request)

      resource = request.resource

      if request.headers != nil and request != nil
        accept = request.headers["Accept"]
        content, content_type = @responseHandler.build(call)
      end


      session.print "HTTP/1.1 200\r\n"
      if content_type then session.print "Content-Type: #{content_type}\r\n" end
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
  p "/ says hello"
  load_file = "/html/hello.html"
  load_file
end
router.add_route("GET", "/hello") do
  p "hello 2"
end
router.add_route("GET", "/ok/:id/test") do |id| ## /ok/4/test
  #p id
  #return File.read("public/html/hello.html")
  p "hi"
  p "id was: #{id}"
  #responseHandler.load(load_file, "/ok/skibidi/test")

end
router.add_route("GET", "/hi/:id/:test") do |id, test| ## /ok/4/test
  puts "id = #{id}"
  puts "test = #{test}"
  load_file = "/html/hello.html"
  load_file
end
router.add_route("POST", "/") do |id|
  puts "hej"
end
router.add_route("POST", "/login") do |params|
  p "recieved post for /login"
  user = params["username"]
  pass = params["password"]
  p user,pass
  return "välkommen"
end

p "org router #{router}"
server = HTTPServer.new(4567, router, responseHandler)
server.start

