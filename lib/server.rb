require 'socket'
require 'pry'

class Server

  def initialize
    @server        = TCPServer.new(9292)
    @request_lines = []
    @request_count = 0
  end

  def start
    loop do
      @client = @server.accept
      @request_lines = []
      while line = @client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end
      respond
      @request_count += 1
    end
  end


  def respond
    response = Response.new
    response = "<pre>" + "Hello World (#{@request_count})" + ("\n") + "</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    @client.puts headers
    @client.puts output
    puts ["Wrote this response:", headers, output].join("\n")
    @client.close
  end


end
