# app.rb
#
# The sinatra app for NeverGonnaGetThatVid
require 'sinatra'

# The main page
get '/' do
  'Hello, world!'
end

# The endpoint URL to "get" the video
post '/' do
end