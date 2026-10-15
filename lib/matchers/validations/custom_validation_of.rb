# frozen_string_literal: true

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

        def description
          options_desc = +"validate field #{@field.inspect}"
          options_desc << " with custom validator #{@custom_validator.name}" if @custom_validator
          options_desc
        end

        private

        def check_validator(actual, validator)
          return false unless (@result = super)
          check_custom_validator(validator) if @custom_validator

          @result
        end

        def check_custom_validator(validator)
          if validator.is_a? @custom_validator
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
