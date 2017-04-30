module Mongoid
  module Matchers
    module Validations
      class ValidateConfirmationOfMatcher < HaveValidationMatcher
        def initialize(name)
          super(name, :confirmation)
        end
      end

      def validate_confirmation_of(field)
        ValidateConfirmationOfMatcher.new(field)
      end
    end
  end
end
