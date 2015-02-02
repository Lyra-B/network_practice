require 'socket'

socket = TCPSocket.new 'localhost/random.jpg', 4567
puts socket.read

