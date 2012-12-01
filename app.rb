require "bundler/setup"
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/assetpack'
require 'erb'

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)
  register Sinatra::AssetPack

  assets {

    serve '/js',     from: 'assets/js'        # Optional
    serve '/css',    from: 'assets/css'       # Optional
    serve '/images', from: 'assets/images'    # Optional

    # The second parameter defines where the compressed version will be served.
    # (Note: that parameter is optional, AssetPack will figure it out.)
    js :app, [
      '/js/chaude_carte.js',
      '/js/app.js'
    ]

    css :application, '/css/application.css', [
      '/css/screen.css'
    ]
  }

  # Home
  get '/' do
    erb :index
  end

  run! if app_file == $0
end


