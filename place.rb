require 'mongoid'
class Place
  include Mongoid::Document

  field :type,      type: String
  field :latlon,    type: Array,   default: []

  index({ latlon: "2d" }, { min: -200, max: 200 })
end

