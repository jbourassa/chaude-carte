require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/assetpack'
require 'erb'

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :run, false
  register Sinatra::AssetPack

  assets {

    serve '/js',     from: 'assets/js'        # Optional
    serve '/css',    from: 'assets/css'       # Optional
    serve '/images', from: 'assets/images'    # Optional

    # The second parameter defines where the compressed version will be served.
    # (Note: that parameter is optional, AssetPack will figure it out.)
    js :headjs, [
      '/js/vendors/jquery-1.8.3.min.js'
    ]
    js :bodyjs, [
      '/js/map.js',
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

  Mongoid.load!('mongoid.yml')

  run! if app_file == $0
end


