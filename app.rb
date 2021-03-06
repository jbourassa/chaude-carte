require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/assetpack'
require 'erb'
require 'json'

Bundler.require(:default)

require_relative 'property'
require_relative 'place'

class App < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :run, false
  register Sinatra::AssetPack

  configure :development do
    register Sinatra::Reloader
  end

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
      '/css/reset.css',
      '/css/screen.css'
    ]
  }


  # Home
  get '/' do
    erb :index, locals: {
      prices: Property.all.to_json,
      trees: IO.read(File.join(settings.root, 'data/trees.json'))
    }
  end

  get '/quebec.json' do
    content_type :json
    box = [[46.888355, -71.485497], [46.709736, -71.119411]]
    Property.where(
      latlon: {"$within" => {"$box" => box }}
    ).map { |p| { latlon: p.latlon, weight: p.price } }.to_json
  end

  get '/trees.json' do
    content_type :json
    arr = JSON.parse(IO.read(File.join(settings.root, 'data/trees.json')))
    arr.map do |point|
      { latlon: [point[1], point[0]] }
    end.to_json
  end

  get '/bus_stops.json' do
    content_type :json
    send_file File.join(settings.root, 'data/bus_stops.json')
  end

  def query_yellow(search, page)
    @client.find_business(search, "Quebec Quebec", { :pgLen => 100, :pg => page })
  end

  get '/restaurants.json' do
    content_type :json
    Place.all.to_json
  end

  Mongoid.load!('mongoid.yml')

  run! if app_file == $0
end
