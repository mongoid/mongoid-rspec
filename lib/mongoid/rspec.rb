$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'mongoid'
require 'rspec/core'
require 'rspec/expectations'
require 'rspec/mocks'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/transform_values' if Mongoid::Compatibility::Version.mongoid4_or_newer?
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'

require 'matchers/associations'
require 'matchers/allow_mass_assignment'
require 'matchers/accept_nested_attributes'
require 'matchers/validations'
require 'matchers/validations/with_message'
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
require 'matchers/be_mongoid_document'
require 'matchers/be_dynamic_document'
require 'matchers/be_stored_in'
require 'matchers/have_field'
if Mongoid::Compatibility::Version.mongoid4_or_newer?
  require 'matchers/have_index_for'
else
  require 'matchers/indexes'
end  
require 'matchers/have_timestamps'

module Mongoid
  module Matchers
    include Mongoid::Matchers::Associations
    include Mongoid::Matchers::Validations
  end
end

# module Mongoid
#   def self.mongoid6?
#     mongoid_version = Gem::Version.new(Mongoid::VERSION)
#     mongoid_version >= Gem::Version.new('6') && mongoid_version < Gem::Version.new('7')
#   end

#   def self.origin_key_class
#     mongoid6? ? Mongoid::Criteria::Queryable::Key : Origin::Key
#   end   
# end
