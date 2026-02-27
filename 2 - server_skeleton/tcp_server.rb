require 'socket'
require './lib/request.rb'
require './lib/router.rb'


class HTTPServer

  def initialize(port, router)
    @port = port
    @router = router
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
      
      if request.get_method == "POST"
        content = session.gets(request.get_content_length)
        request.get_post_params(content)
      end
      
      p "new router = #{@router}"
      @router.handle_resource(request)

      html = "<h1>Hello, World!</h1>"

      session.print "HTTP/1.1 200\r\n"
      session.print "Content-Type: text/html\r\n"
      session.print "\r\n"
      session.print html
      session.close
    end
  end
end

router = Router.new()

router.add_route("GET", "/hello") do
  p "hello"
end
router.add_route("GET", "/ok/:id/test") do |id| ## /ok/4/test
  what = id
end

p "org router #{router}"
server = HTTPServer.new(4567, router)
server.start

