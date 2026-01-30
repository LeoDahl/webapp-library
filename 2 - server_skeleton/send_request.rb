require 'socket'

socket = TCPSocket.new('localhost', 4567)
socket.print File.read('../1 - example_requests/get-index.request.txt')
puts socket.read
socket.close
