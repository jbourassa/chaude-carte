#! /usr/bin/env ruby
require_relative "app.rb"
require_relative "place.rb"
require 'awesome_print'

@client = YellowApi.new(:apikey => "dygfhqympjmzeeysmwsknbem", :sandbox_enabled => true)
def call(query, page)
  results = @client.find_business(query, "Quebec Quebec", { :pgLen => 100, :pg => page })
  results.listings.compact.select(&:geo_code)
end

start = Time.now

page = 1
query = 'restaurants'
Place.destroy_all
while true do
  results = call(query, page)
  break if results.length.zero?

  puts "Scraped #{results.length} records on page #{page}."

  results.map do |result|
    Place.create({
      type: query,
      latlon: [
        result['geo_code']['latitude'],
        result['geo_code']['longitude']
      ]
    })
  end
  puts "Saved. Place count: #{Place.count}"

  page += 1
  sleep 2
end

puts "Took #{Time.now - start}s"
