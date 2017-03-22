# app.rb
#
# The sinatra app for NeverGonnaGetThatVid
require 'sinatra'
require 'json'

helpers do

  def get_video_id(video_url)
    return nil unless valid_url(video_url)
    nil
  end

  def send_response(successful, message, video_info = nil)
    # successful => bool, message => string, video_info => hash with details of the video
    { successful: successful, message: message, video_info: video_info }.to_json
  end

  def valid_url(video_url)
    video_url.match(/www.youtube.com\/watch\?v=[a-zA-Z0-9]+/) || video_url.match(/www.youtu.be\/[0-9A-Za-z]+/)
  end
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
    id = get_video_id(params['video_url'])

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