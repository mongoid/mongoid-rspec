module Mongoid
  module Matchers
    module Validations
      class ValidateConfirmationOfMatcher < HaveValidationMatcher
        include WithMessage

        def initialize(name)
          super(name, :confirmation)
        end

        def with_message(message)
          @expected_message = message
          self
        end
      end

      def validate_confirmation_of(field)
        ValidateConfirmationOfMatcher.new(field)
      end
    end
  end
end
