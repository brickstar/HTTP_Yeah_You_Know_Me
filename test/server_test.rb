require './test/test_helper'
require './lib/server'

class ServerTest < MiniTest::Test

  def test_server_exists
    skip
    server = Server.new

    assert_instance_of Server, server
  end
end
