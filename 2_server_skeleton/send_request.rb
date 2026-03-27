require 'socket'

socket = TCPSocket.new('localhost', 4567)
socket.print File.read('post-login.request.txt')
puts socket.read
socket.close


