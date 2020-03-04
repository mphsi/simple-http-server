require "socket"
require "rack"
require "rack/lobster"

server = TCPServer.new 5678
app    = Rack::Lobster.new

while session = server.accept
  request = session.gets
  puts request

  method, full_path     = request.split(" ")
  path, query           = full_path.split("?")
  status, headers, body = app.call({
    "REQUEST_METHOD" => method,
    "PATH_INFO" => path,
    "QUERY_STRING" => query
  })

  session.print "HTTP/1.1 #{status}\r\n"
  headers.each{ |key, value| session.print "#{key}: #{value}\r\n" }
  session.print "\r\n"
  body.each{ |part| session.print part }

  session.close
end
