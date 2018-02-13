require 'socket'
require 'pry'
tcp_server = TCPServer.new(9292)

#opens server

client = tcp_server.accept

puts "Ready for a request"
request_lines = []
# binding.pry
while line = client.gets and !line.chomp.empty?
  request_lines << line.chomp
end
# binding.pry
puts "Got this request:"
puts request_lines.inspect

#sends response
puts "Sending response."
response = "<pre>" + request_lines.join("\n") + "</pre>"
# binding.pry
output = "<html><head></head><body>#{response}</body></html>"
# binding.pry

headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"].join("\r\n")
client.puts headers
client.puts output

#closes the server
puts ["Wrote this response:", headers, output].join("\n")
client.close
puts "\nResponse complete, exiting."
end
