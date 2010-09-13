module Mongoid
  module Matchers
    module Validations
      def validate_length_of(field)
        HaveValidationMatcher.new(field, :length)
      end
    end
  end
end