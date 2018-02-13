class Response
  attr_reader :verb,
              :path,
              :protocol,
              :host,
              :port,
              :origin,
              :accept

  def initialize

  end

  def parse
    @vpp = @request_lines.shift.split(" ") #array of [verb, path, protocol]
    @hash = @request_lines.map {|key| key.split(": ")}.to_h # hash of rest of required lines
  end

  def debug_information
    @verb      = @vpp[0]
    @path      = @vpp[1]
    @protocol  = @vpp[2]
    host_port  = @hash["Host"].split(":")
    @host      = host_port[0]
    @port      = host_port[1]
    @origin    = @host
    @accept    = @hash["Accept"]
  end

  def puts_diagnostics
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
end
