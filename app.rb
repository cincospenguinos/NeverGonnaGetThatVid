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

  def send_response(successful, message)
    { successful: successful, message: message }.to_json
  end

  def valid_url(video_url)
    
  end
end

# The main page
get '/' do
  erb :index
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