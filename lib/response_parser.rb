class ResponseParser

  def parse
    verb_path_protocol = @request_lines.shift.split(" ")
    hash = @request_lines.map {|x| x.split(":",2)}.to_h
end
