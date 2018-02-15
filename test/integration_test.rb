require './test/test_helper'

class IntegrationTest < MiniTest::Test

  def test_standard_get_response
    response = Faraday.get 'http://127.0.0.1:9292/'
    expected = "<html><head></head><body>\n<pre>\nVerb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: */*\n</pre>\n</body></html>"

    assert_equal expected, response.body
  end

  def test_hello_path
    response = Faraday.get 'http://127.0.0.1:9292/hello'

    assert response.body.include?("Hello, World")
  end

  def test_datetime_path
    response = Faraday.get 'http://127.0.0.1:9292/datetime'
    expected = "<html><head></head><body>\n<pre>\n#{Time.now.strftime('%l:%M %p on %A, %B %d, %C%y')}\n</pre>\n</body></html>"

    assert_equal expected, response.body
  end

  def test_shutdown_path
    response = Faraday.get 'http://127.0.0.1:9292/shutdown'
    expected = "<html><head></head><body>\n<pre>\nTotal Requests: 41\n</pre>\n</body></html>"

    assert response.body.include?("Total Requests:")
  end

  def test_start_game_path
    response = Faraday.get 'http://127.0.0.1:9292/start_game'
  end

  def test_game_path
    response = Faraday.get 'http://127.0.0.1:9292/game'
  end

end
