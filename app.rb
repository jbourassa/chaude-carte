require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/assetpack'
require 'erb'

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)
  register Sinatra::AssetPack

  assets {

    serve '/js',     from: 'app/js'        # Optional
    serve '/css',    from: 'app/css'       # Optional
    serve '/images', from: 'app/images'    # Optional

    # The second parameter defines where the compressed version will be served.
    # (Note: that parameter is optional, AssetPack will figure it out.)
    js :app, [
      '/js/vendor/**/*.js',
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


