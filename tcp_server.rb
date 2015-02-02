require 'socket'

server = TCPServer.new 4567


html = <<HTML
<h1> My site </h1>
<body>
	<h2>This is my site</h2>


</body>
HTML

def response(body, type = "text/html; charset=UTF-8")
<<RESPONSE
HTTP/1.1 200 OK
Location: http://localhost
Content-Type: #{type}
Date: #{Time.now}
Server: #{self.class}
Content-Length: #{body.length}
Alternate-Protocol : 80:quic, p=0.02

#{body}
RESPONSE
end

while true 
	puts "waiting for connection"
  link = server.accept
  request = link.recvmsg
  path = request.first.split(" ")[1]
  if path.start_with? ('/public')
  	link.puts response(File.read(Dir.pwd + path), "image/jpeg")
  elsif path.include? "random"
  	link.puts response(File.read(Dir.glob("public/images/*.jpg").sample), "image/jpeg")
  else
  	link.puts response(html)
  end
	link.close
end


