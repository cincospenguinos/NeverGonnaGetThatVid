# app.rb
#
# The sinatra app for NeverGonnaGetThatVid
require 'sinatra'
require 'json'
require 'yaml'
require 'net/http'

helpers do

  def get_video_info(video_url)
    return nil if (video_id = extract_video_id(video_url)).nil?
    url = URI.parse("#{settings.api_url_endpoint}?id=#{video_id}&key=#{settings.api_key}&part=snippet&fields=#{settings.fields}")
    res = Net::HTTP.get(url)
    JSON.parse(res)
  end

  def send_response(successful, message, video_info = nil)
    # successful => bool, message => string, video_info => hash with details of the video
    { successful: successful, message: message, video_info: video_info }.to_json
  end

  def extract_video_id(video_url)
    return nil unless video_url.match(/www.youtube.com\/watch\?v=[a-zA-Z0-9]+/) || video_url.match(/www.youtu.be\/[0-9A-Za-z]+/)
    if video_url.match(/www.youtube.com\/watch\?v=[a-zA-Z0-9]+/)
      video_url[/v=[a-zA-Z0-9]+/].gsub('v=', '')
    else
      video_url[/\/[a-zA-Z0-9]+/].gsub('/', '')
    end
  end
end

configure do
  set :api_url_endpoint, 'https://www.googleapis.com/youtube/v3/videos'
  set :api_key, YAML.load_file('.api_key.yaml')['API_KEY']
  set :fields, 'items(snippet(title, thumbnails))'
end

# The main page
get '/' do
  erb :index
end

# Returns the video
get '/*' do
  # TODO: This
end

# The endpoint URL to "get" the video
post '/' do
  if params.include?('video_url')
    id = get_video_info(params['video_url'])

    if id.nil?
      send_response(false, 'Invalid URL! Could not get video ID!')
    else
      # TODO: "Grab" the video
      send_response(true, 'Grabbing the video...')
    end
  else
    send_response(false, 'No URL provided!')
  end
end












