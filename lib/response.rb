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
      get_hello
    elsif @path == "/datetime"
      get_datetime
    elsif @path == "/shutdown"
      get_shutdown
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
      binding.pry
      start_game
    elsif @path == "/game" && @verb == "POST"
      content_guess = client.read(@content_length).split[-2].to_i
      @game.user_guess(content_guess)
      @game.gameplay
    elsif @path == "/game" && @verb == "GET"
      @game.game_information
    else
      "404 Not Found"
    end
  end

  def debug_information
    "Verb: #{@verb}\nPath: #{@path}\nProtocol: #{@protocol}\nHost: #{@host}\nPort: #{@port}\nOrigin: #{@origin}\nAccept: #{@accept}"
  end

  def get_hello
    "Hello, World! (#{server.request_count})"
  end

  def get_datetime
    "#{Time.now.strftime('%l:%M %p on %A, %B %d, %C%y')}"
  end

  def get_shutdown
    "Total Requests: #{server.request_count}"
  end

  def word_search
    word = @path.split("=")[1]
    file = File.read("/usr/share/dict/words")
    if file.include?"#{word.downcase}"
      "#{word.downcase} is a known word."
    else
      "#{word.downcase} is not a known word."
    end
  end
end
