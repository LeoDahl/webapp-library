require './lib/router.rb'
require './lib/tcp_server.rb'

router = Router.new()


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
end
router.add_route("GET", "/abc") do
  load_file = "/html/abc.html"
  load_file
end

server = HTTPServer.new(4567, router)

server.start


