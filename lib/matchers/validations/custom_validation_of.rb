module Mongoid
  module Matchers
    module Validations
      class ValidateWithCustomValidatorMatcher < HaveValidationMatcher
        def initialize(field)
          super(field, :custom)
        end

        def with_validator(custom_validator)
          @custom_validator = custom_validator
          self
        end

        def matches?(actual)
          return false unless (@result = super(actual))
          check_custom_validator if @custom_validator

          @result
        end

        def description
          options_desc = []
          options_desc << " with custom validator #{@custom_validator.name}" if @validator
          "validate field #{@field.inspect}" << options_desc.to_sentence
        end

        private

        def check_custom_validator
          if @validator.is_a? @custom_validator
            @positive_result_message << " with custom validator of type #{@custom_validator.name}"
          else
            @negative_result_message << " with custom validator not of type #{@custom_validator.name}"
            @result = false
          end
        end
      end

      def custom_validate(field)
        ValidateWithCustomValidatorMatcher.new(field)
      end
    end
  end
end
