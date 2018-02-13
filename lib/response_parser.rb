class ResponseParser

  def initialize
    @verb     = vpp[0]
    @path     = vpp[1]
    @protocol = vpp[2]
  end

  def parse
    vpp = @request_lines.shift.split(" ") #array of [verb, path, protocol]
    hash = @request_lines.map {|x| x.split(":", 2)}.to_h # hash of rest of required lines
  end

  def debug_information
    @verb     =
    @path     =
    @protocol =
    host     =
    port     =
    origin   =
    accept   =

    <<-END
      <pre>
      Verb: #{verb}
      Path: #{path}
      Protocol: #{protocol}
      Host: #{host}
      Port: #{port}
      Origin: #{origin}
      Accept: #{accept}
      </pre>
    END
  end
end
