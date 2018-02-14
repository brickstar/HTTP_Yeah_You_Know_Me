require 'minitest/autorun'
require 'minitest/pride'
require './lib/server'

class ServerTest < MiniTest::Test

  def test_server_exists
    server = Server.new

    assert_instance_of Server, server
  end


end
