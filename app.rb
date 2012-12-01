require "bundler/setup"
require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'

# Home
get '/' do
  erb :index
end
