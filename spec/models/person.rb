require 'ssn_validator.rb'

class Person

  include Mongoid::Document

  field :name
  field :ssn

  validates :ssn, ssn: true


end