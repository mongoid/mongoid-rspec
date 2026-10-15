# frozen_string_literal: true

require 'logger'
require 'active_record'
require 'mongoid-rspec'
require 'shoulda/matchers'

RSpec.configure do |config|
  config.include Mongoid::Matchers, type: :mongoid_model
  config.include Shoulda::Matchers::ActiveModel, type: :model
  config.include Shoulda::Matchers::ActiveRecord, type: :model
  config.disable_monkey_patching!
end
