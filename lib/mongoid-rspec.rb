$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'mongoid'
require 'rspec'
require 'matchers/document'
require 'matchers/associations'
require 'matchers/validations'
require 'matchers/validations/associated'
require 'matchers/validations/format_of'
require 'matchers/validations/inclusion_of'
require 'matchers/validations/length_of'
require 'matchers/validations/numericality_of'
require 'matchers/validations/presence_of'
require 'matchers/validations/uniqueness_of'

module Mongoid
  module Matchers
    include Mongoid::Matchers::Associations
    include Mongoid::Matchers::Validations
  end
end
