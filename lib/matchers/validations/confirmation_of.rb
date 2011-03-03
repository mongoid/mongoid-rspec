module Mongoid
  module Matchers
    module Validations  
      def validate_confirmation_of(field)
        HaveValidationMatcher.new(field, :confirmation)
      end
    end
  end
end  
