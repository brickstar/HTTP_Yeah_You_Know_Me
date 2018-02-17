require './test/test_helper'

class IntegrationTest < MiniTest::Test

  def test_standard_get_response
    response = Faraday.get 'http://127.0.0.1:9292/'
    expected = "<html><head></head><body>\n<pre>\nVerb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept: */*\n</pre>\n</body></html>"

    assert_equal expected, response.body
  end

  def test_get_hello
    response = Faraday.get 'http://127.0.0.1:9292/hello'

    assert response.body.include?("Hello, World")
  end

  def test_get_datetime
    response = Faraday.get 'http://127.0.0.1:9292/datetime'
    expected = "<html><head></head><body>\n<pre>\n#{Time.now.strftime('%l:%M %p on %A, %B %d, %C%y')}\n</pre>\n</body></html>"

    assert_equal expected, response.body
  end

  def test_word_search
    response = Faraday.get 'http://127.0.0.1:9292/word_search?word=hello'
    expected = "<html><head></head><body>\n<pre>\nhello is a known word.\n</pre>\n</body></html>"

    assert_equal expected, response.body

    response = Faraday.get 'http://127.0.0.1:9292/word_search?word=asdf'
    expected = "<html><head></head><body>\n<pre>\nasdf is not a known word.\n</pre>\n</body></html>"

    assert_equal expected, response.body
  end
end
