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
  end

  def start_game
    Game.new
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

  def split
    @verb_path_protocol = server.request_lines.shift.split(" ")
    @hash = server.request_lines.map {|key| key.split(": ")}.to_h
  end

  def debug_information
    split
    @verb      = @verb_path_protocol[0]
    @path      = @verb_path_protocol[1]
    @protocol  = @verb_path_protocol[2]
    host_port  = @hash["Host"].split(":")
    @host      = host_port[0]
    @port      = host_port[1]
    @origin    = @host
    @accept    = @hash["Accept"]
  end

  def response
    debug_information
    if @path == "/"
      "Verb: #{@verb}\nPath: #{@path}\nProtocol: #{@protocol}\nHost: #{@host}\nPort: #{@port}\nOrigin: #{@origin}\nAccept: #{@accept}"
    elsif @path == "/hello"
      "Hello, World! (#{server.request_count})"
    elsif @path == "/datetime"
      "#{Time.now.strftime('%l:%M %p on %A, %B %d, %C%y')}"
    elsif @path == "/shutdown"
      "Total Requests: #{server.request_count}"
    elsif @path.split("=")[0] == "/word_search?word"
      word_search
    elsif @path == "/start_game" && @verb == "POST"
      start_game
      "Good Luck!"
    elsif @path == "/game" && @verb == "POST"
      guess = server.request_lines.find {|body| body.include?('guess')}.split[-1]
      game.user_guess(guess)
    else
      "404 Not Found"
    end
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
