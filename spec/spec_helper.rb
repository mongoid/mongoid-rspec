$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))
MODELS = File.join(File.dirname(__FILE__), "models")
$LOAD_PATH.unshift(MODELS)

require "rubygems"
require "bundler"
Bundler.setup

require 'rspec'
require 'rspec/core'
require 'rspec/expectations'
require 'mongoid'

Mongoid.configure do |config|
  name = "mongoid-rspec-test"
  host = "localhost"
  config.master = Mongo::Connection.new.db(name)
end

Dir[ File.join(MODELS, "*.rb") ].sort.each { |file| require File.basename(file) }

require 'mongoid-rspec'

RSpec.configure do |config|
  config.include RSpec::Matchers
  config.include Mongoid::Matchers
  config.mock_with :rspec
  config.after :all do
    Mongoid.master.collections.each(&:drop)
  end
end
