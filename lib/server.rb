require 'socket'
require 'pry'
require_relative 'response'

class Server

attr_reader :request_lines,
            :request_count,
            :client

  def initialize
    @server        = TCPServer.new(9292)
    @response      = Response.new(self)
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
      @response.respond
      @request_count += 1
      puts @request_lines.inspect
    end
  end
end
