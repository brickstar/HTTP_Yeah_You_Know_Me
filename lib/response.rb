require_relative 'server'
require 'date'
require 'pry'
require './lib/game'

class Response
  attr_reader :verb,
              :path,
              :protocol,
              :host,
              :port,
              :origin,
              :accept,
              :server

  def initialize(server)
    @server = server
    @game   = nil
  end

  def client
    @server.client
  end


  def respond
    output = "<html><head></head><body>\n<pre>\n#{response}\n</pre>\n</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    server.client.puts headers
    server.client.puts output
  end

  def split_request_lines
    @verb_path_protocol = server.request_lines.shift.split(" ")
    @hash = server.request_lines.map {|key| key.split(": ")}.to_h
  end

  def parse_request_lines
    split_request_lines
    @verb      = @verb_path_protocol[0]
    @path      = @verb_path_protocol[1]
    @protocol  = @verb_path_protocol[2]
    host_port  = @hash["Host"].split(":")
    @host      = host_port[0]
    @port      = host_port[1]
    @origin    = @host
    @accept    = @hash["Accept"]
    @content_length = @hash["Content-Length"].to_i
  end

  def response
    if @path == "/"
      debug_information
    elsif @path == "/hello"
      hello_path
    elsif @path == "/datetime"
      datetime_path
    elsif @path == "/shutdown"
      shutdown_path
    elsif @path.split("=")[0] == "/word_search?word"
      word_search
    else
      game_handler
    end
  end

  def start_game
    @game = Game.new
    'Good Luck!'
  end

  def game_handler
    if @path == "/start_game" && @verb == "POST"
      start_game
    elsif @path == "/game" && @verb == "POST"
      #stuff
    else
      "404 Not Found"
    end
  end

  def debug_information
    "Verb: #{@verb}\nPath: #{@path}\nProtocol: #{@protocol}\nHost: #{@host}\nPort: #{@port}\nOrigin: #{@origin}\nAccept: #{@accept}"
  end

  def shutdown_path
    "Total Requests: #{server.request_count}"
  end

  def hello_path
    "Hello, World! (#{server.request_count})"
  end

  def datetime_path
    "#{Time.now.strftime('%l:%M %p on %A, %B %d, %C%y')}"
  end

  def word_search
    word = @path.split("=")[1]
    file = File.read("/usr/share/dict/words")
    if file.include?"#{word}"
      "#{word} is a known word."
    else
      "#{word} is not a known word."
    end
  end
end
