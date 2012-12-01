require 'mongoid'
class Property
  include Mongoid::Document

  field :code,      type: Integer
  field :group,     type: String
  field :type,      type: String
  field :price,     type: Integer
  field :date,      type: Date
  field :latlon,    type: Array,   default: []

  index({ latlon: "2d" }, { min: -200, max: 200 })
  index({code: 1}, {unique: true})
end
