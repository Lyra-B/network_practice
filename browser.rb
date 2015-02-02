require 'socket'
require 'pry'

class MyAmazingBrowser
  attr_accessor :host, :port

  def initialize(port = 80)
    @port = port
  end

  def connect(request, &block)
    socket = TCPSocket.open(host, port)
    socket.puts(request)
    block.call socket.read
    socket.close
  end

  def get(url, &block)
    self.host, path = get_host_and_path(url)

  # I couldn't get this indent nicely ...
request = <<-REQUEST_HEADERS
GET #{path} HTTP/1.0
User-Agent: MyAmazingBrowser
Host: #{@host}
Accept-Language: en

REQUEST_HEADERS

    connect(request, &block)
  end

  def prompt_user_for_path
    puts "What URL would you like to visit?"
    print "> "
    gets.strip.chomp
  end

  private
  def get_host_and_path(url)
    parts = url.split("/")
    return parts[2], "/#{parts[3..parts.length].join("/")}"
  end
end

# Example use...
browser = MyAmazingBrowser.new

url = browser.prompt_user_for_path

browser.get(url) do |response|
  File.open("downloadedpage.html", "w") { |file|
    file.write response
  }
  puts response
end