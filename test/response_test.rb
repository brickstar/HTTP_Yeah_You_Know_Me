require './lib/response.rb'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

class ResponseTest < Minitest::Test

  def test_verb_exists
    response = Response.new

  end

  def test_path_exists
    response = Response.new

    assert_equal /hello, response.diagnostics
  end

  def test_protocol_exists

  end

  def test_host_exists

  end

  def test_port_exists

  end

  def test_origin_exists

  end


  def test_accept_exists

  end


end
