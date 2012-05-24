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

        def with_message(message)
          @expected_message = message
          self
        end

        def matches?(actual)
          return false unless (@result = super(actual))
          check_custom_validator if @custom_validator
          check_expected_message if @expected_message

          @result
        end

        def description
          options_desc = []
          options_desc << " with custom validator #{@custom_validator.name}" if @validator
          options_desc << " with message '#{@expected_message}'" if @expected_message
          "validate field #{@field.inspect}" << options_desc.to_sentence
        end

        private

        def check_custom_validator
          if @validator.kind_of? @custom_validator
            @positive_result_message << " with custom validator of type #{@custom_validator.name}"
          else
            @negative_result_message << " with custom validator not of type #{@custom_validator.name}"
            @result = false
          end
        end

        def check_expected_message
          actual_message = @validator.options[:message]
          if actual_message.nil?
            @negative_result_message << " with no custom message"
            @result = false
          elsif actual_message == @expected_message
            @positive_result_message << " with custom message '#{@expected_message}'"
          else
            @negative_result_message << " got message '#{actual_message}'"
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