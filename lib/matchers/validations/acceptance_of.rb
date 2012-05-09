module Mongoid
  module Matchers
    module Validations  
      def validate_acceptance_of(field)
        HaveValidationMatcher.new(field, :acceptance)
      end
    end
  end
end  
