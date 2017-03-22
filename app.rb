# app.rb

require 'sinatra'
require 'json'
require 'yaml'
require 'net/http'

configure do
  set :api_url, 'https://www.googleapis.com/youtube/v3/videos'
  set :api_key, YAML.load_file('.api_key.yaml')['API_KEY'] # TODO: Don't do this
  set :fields, 'items(snippet(title, thumbnails))'
end

helpers do

  def get_video_info(video_url)
    return nil if (video_id = extract_video_id(video_url)).nil?
    url = URI.parse("#{settings.api_url}?id=#{video_id}&key=#{settings.api_key}&part=snippet&fields=#{settings.fields}")
    res = JSON.parse(Net::HTTP.get(url))
    res['url'] = video_url
    res
  end

  def send_response(successful, message, video_info = nil)
    { successful: successful, message: message, video_info: video_info }.to_json
  end

  def extract_video_id(video_url)
    return nil unless video_url.match(/www.youtube.com\/watch\?v=\S+/) || video_url.match(/youtu.be\/\S+/)

    if video_url.match(/www.youtube.com\/watch\?v=[a-zA-Z0-9]+/)
      video_url[/v=\S+/].gsub('v=', '')
    else
      video_url[/be\/\S+/].gsub('/', '').gsub('be', '')
    end
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

# Returns the status of the video provided
get '/status/*' do

end

# The endpoint URL to "get" the video
post '/' do
  if params.include?('video_url')
    id = get_video_info(params['video_url'])

    if id.nil?
      send_response(false, 'That is not a valid URL')
    else
      video_info = get_video_info(params['video_url'])

      if video_info['items'].size == 0
        send_response(false, 'Could not find a video at that URL')
      else
        # TODO: This is where we "grab" the video and setup a link to it
        send_response(true, 'Grabbing the video...', video_info)
      end
    end
  else
    send_response(false, 'No URL provided!')
  end
end












