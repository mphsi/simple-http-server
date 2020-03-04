require "socket"
require "rack"
require "rack/lobster"

server = TCPServer.new 5678
app    = Rack::Lobster.new

while session = server.accept
  request = session.gets
  puts request

  status, headers, body = app.call({})

  session.print "HTTP/1.1 #{status}\r\n"
  headers.each{ |key, value| session.print "#{key}: #{value}\r\n" }
  session.print "\r\n"
  body.each{ |part| session.print part }

  session.close
end
