#! /usr/bin/env ruby
require_relative "app.rb"
require_relative "property.rb"
require 'awesome_print'
require 'pry'

KEYS = YAML::load(File.open('keys.yml'))
URL = 'http://api-beta.duproprio.com'

hash = %q{/g-ci=72-73-109-152-172-175-17777-302-1299-1382-1424-1543-1650-1756-415-416-489-505-558-559-17750-1807-17791-643-1806-17792-1808-1805-17795-878-22042-19728-22501-974-986-1167-1262-1292-1316-23427-1394-1593-1612-1616-1763-999-1000-1044-1060-18363-1895/s-pmin=0/s-pmax=99999999/s-build=1/s-days=/m-pack=house-condo-cottage-multiplex-terr-comm-farm/p-con=main/p-ord=date/p-dir=DESC/pa-ge=1/#/g-ci=72-73-109-152-172-175-17777-302-1299-1382-1424-1543-1650-1756-415-416-489-505-558-559-17750-1807-17791-643-1806-17792-1808-1805-17795-878-22042-19728-22501-974-986-1167-1262-1292-1316-23427-1394-1593-1612-1616-1763-999-1000-1044-1060-18363-1895/s-pmin=0/s-pmax=99999999/s-build=1/s-filter=sold/m-pack=house-condo-cottage-multiplex-terr-comm-farm/p-con=main/p-ord=date/p-dir=ASC/pa-ge=1/}


def call(call, params={})
  params[:brand] ||= 'dp'
  response = RestClient.get("#{URL}/#{call}", params: params.merge(KEYS).merge(lang: 'fr'))
  as_hash = Hash.from_xml(response.to_str)
  if as_hash['response'] && as_hash['response']['listingList']
    as_hash['response']['listingList']['listing']
  else
    nil
  end
end

start = Time.now

page = 0
while true do
  results = call('getlistingsbyhash',
    hash: hash,
    maxresults: 100,
    page: page
  )

  break unless results

  puts "Scraped #{results.length} records on page #{page}."
  properties = results.map do |result|
    result['price'] = result['price'].gsub(/\s+|\$/, '')
    result['lat'] = result['lat'].to_f
    result['lon'] = result['lon'].to_f
    next if result['lat'].zero? || result['lon'].zero?

    Property.create(
      code: result['code'],
      group: result['group'],
      type: result['type'],
      price: result['price'],
      date: result['onlineSince'],
      latlon: [result['lon'], result['lat']]
    )
  end
  puts "Saved. Properties count: #{Property.count}"


  page += 1
end

puts "Took #{Time.now - start}s"
