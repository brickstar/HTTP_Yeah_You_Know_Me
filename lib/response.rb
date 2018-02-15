require_relative 'server'
require 'date'
require 'pry'

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

  def respond
    response_1 = "<pre>" + "#{response}" + ("\n") + "</pre>"
    output = "<html><head></head><body>#{response_1}</body></html>"
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
    diagnostics
    if @path == "/"
      <<-END
        <pre>
        Verb: #{@verb}
        Path: #{@path}
        Protocol: #{@protocol}
        Host: #{@host}
        Port: #{@port}
        Origin: #{@origin}
        Accept: #{@accept}
        </pre>
        END
    elsif @path == "/hello"
      " Hello, World! (#{server.request_count})"
    elsif @path == "/datetime"
      "#{Time.now.strftime('%l:%M %p on %A, %B %d, %C%y')}"
    elsif @path == "/shutdown"
      "Total Requests: #{server.request_count}"
    elsif @path.split("=")[0] == "/word_search?word"
      word_search
    else
      "404 Not Found"
    end
  end

  def diagnostics
    debug_information
    <<-END
      <pre>
      Verb: #{@verb}
      Path: #{@path}
      Protocol: #{@protocol}
      Host: #{@host}
      Port: #{@port}
      Origin: #{@origin}
      Accept: #{@accept}
      </pre>
    END
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
