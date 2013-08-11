module Mongoid
  module Matchers
    module Validations
      class ValidateExclusionOfMatcher < HaveValidationMatcher
        def initialize(name)
          super(name, :exclusion)
        end

        def to_not_allow(*values)
          @not_allowed_values = [values].flatten
          self
        end

        def matches?(actual)
          return false unless result = super(actual)

          if @not_allowed_values
            raw_validator_not_allowed_values = @validator.options[:in]

            validator_not_allowed_values = case raw_validator_not_allowed_values
            when Range then raw_validator_not_allowed_values.to_a
            when Proc then raw_validator_not_allowed_values.call(actual)
            else raw_validator_not_allowed_values end

            allowed_values = @not_allowed_values - validator_not_allowed_values
            if allowed_values.empty?
              @positive_result_message = @positive_result_message << " not allowing all values mentioned"
            else
              @negative_result_message = @negative_result_message << " allowing the following the ff. values: #{allowed_values.inspect}"
              result = false
            end
          end

          result
        end

        def description
          options_desc = []
          options_desc << " not allowing the ff. values: #{@not_allowed_values}" if @not_allowed_values
          super << options_desc.to_sentence
        end
      end

      def validate_exclusion_of(field)
        ValidateExclusionOfMatcher.new(field)
      end
    end
  end
end