#! /usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require "active_support/all"
Bundler.require(:default)

require_relative "app.rb"
require_relative "property.rb"

Property.create_indexes()