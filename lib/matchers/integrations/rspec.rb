# :enddoc:
require 'rspec/core'

RSpec.configure do |config|
  require 'matchers/associations'
  require 'matchers/validations'
  config.include Mongoid::Matchers::Associations, type: :model
  config.include Mongoid::Matchers::Validations, type: :model
end
