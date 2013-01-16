$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'mongoid'
require 'rspec'
require "active_model"
require 'matchers/document'
require 'matchers/associations'
require 'matchers/collections'
require 'matchers/indexes'
require 'matchers/allow_mass_assignment'
require 'matchers/accept_nested_attributes'
require 'matchers/validations'
require 'matchers/validations/associated'
require 'matchers/validations/confirmation_of'
require 'matchers/validations/exclusion_of'
require 'matchers/validations/format_of'
require 'matchers/validations/inclusion_of'
require 'matchers/validations/length_of'
require 'matchers/validations/numericality_of'
require 'matchers/validations/presence_of'
require 'matchers/validations/uniqueness_of'
require 'matchers/validations/acceptance_of'
require 'matchers/validations/custom_validation_of'

module Mongoid
  module Matchers
    include Mongoid::Matchers::Associations
    include Mongoid::Matchers::Validations
  end
end
