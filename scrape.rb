#! /usr/bin/env ruby
require_relative "app.rb"
require_relative "property.rb"


KEYS = {
  appid: ENV['DP_APPID'],
  username: ENV['DP_USERKEY'],
  userkey: ENV['DP_USERNAME'],
}
URL = 'http://api-beta.duproprio.com'

def call(call, params={})
  params[:brand] ||= 'dp'
  response = RestClient.get("#{URL}/#{call}", params: params.merge(KEYS).merge(lang: 'fr'))
  as_hash = Hash.from_xml(response.to_str)

  as_hash['response']['listingList']['listing']
end

start = Time.now

results = call('getlistingsbycoordinates',
  maxresults: 10,
  km: 5,
  lat: '46.802997',
  lon: '-71.243099'
)

puts "Scraped #{results.length} records."
properties = results.map do |result|
  Property.create(
    code: result['code'],
    group: result['group'],
    type: result['type'],
    price: result['price'],
    date: result['onlineSince'],
    latlon: [result['lat'], result['lon']]
  )
end
puts "Saved. Properties count: #{Property.count}"
puts "Took #{Time.now - start}s"
