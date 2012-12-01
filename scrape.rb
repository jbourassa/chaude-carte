#! /usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require "active_support/all"
Bundler.require(:default, :development)

require_relative "app.rb"
require_relative "property.rb"


KEYS = YAML::load(File.open('keys.yml'))
URL = 'http://api-beta.duproprio.com'

def call(call, params={})
  params[:brand] ||= 'dp'
  response = RestClient.get("#{URL}/#{call}", params: params.merge(KEYS).merge(lang: 'fr'))
  as_hash = Hash.from_xml(response.to_str)

  as_hash['response']['listingList']['listing']
end


results = call('getlistingsbycoordinates',
  maxresults: ,
  km: 5,
  lat: '46.802997',
  lon: '-71.243099'
)

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
