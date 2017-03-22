ENV['RACK_ENV'] = 'test'

require_relative '../app.rb'
require 'test/unit'
require 'rack/test'
require 'json'

class HelloWorldTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_is_ok
    get '/'
    assert last_response.ok?
  end

  def test_no_url
    post '/'
    body = JSON.parse(last_response.body)
    assert last_response.ok?
    assert !body['successful']
  end

  def test_invalid_url_site
    post '/', params = { video_url: 'www.pootube.com/watch?v=ABUNCHOFSHIZ'}
    body = JSON.parse(last_response.body)
    assert last_response.ok?
    assert !body['successful']
  end

  def test_invalid_url_bad_setup
    post '/', params = { video_url: 'www.youtube.com/wach?v=ABUNCHOFSHIZ'}
    body = JSON.parse(last_response.body)
    assert last_response.ok?
    assert !body['successful']
  end

  def test_invalid_url_xss_attack
    post '/', params = { video_url: '<script>alert("haxxed");</script>www.youtube.com/wach?v=ABUNCHOFSHIZ'}
    body = JSON.parse(last_response.body)
    assert last_response.ok?
    assert !body['successful']
  end

  def test_invalid_url_video_does_not_exist
    post '/', params = { video_url: 'www.youtube.com/watch?v=SOMEBULLSHIZID'}
    body = JSON.parse(last_response.body)
    assert last_response.ok?
    assert !body['successful']
  end

  def test_valid_url
    post '/', params = { video_url: 'https://www.youtube.com/watch?v=Dkm8Hteeh6M'}
    body = JSON.parse(last_response.body)
    assert last_response.ok?
    assert body['successful']

    post '/', params = { video_url: 'https://youtu.be/CcHt9tW8oo0'}
    body = JSON.parse(last_response.body)
    assert last_response.ok?
    assert body['successful']
  end
end