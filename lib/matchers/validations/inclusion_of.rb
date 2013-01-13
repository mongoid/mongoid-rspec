module Mongoid
  module Matchers
    module Validations
      class ValidateInclusionOfMatcher < HaveValidationMatcher
        def initialize(name)
          super(name, :inclusion)
        end

        def to_allow(*values)
          @allowed_values = values.map(&:to_a).flatten
          self
        end

        def matches?(actual)
          return false unless result = super(actual)

          if @allowed_values
            raw_validator_allowed_values = @validator.options[:in]

            validator_allowed_values = case raw_validator_allowed_values
            when Range then raw_validator_allowed_values.to_a
            when Proc then raw_validator_allowed_values.call(actual)
            else raw_validator_allowed_values end

            not_allowed_values = @allowed_values - validator_allowed_values
            if not_allowed_values.empty?
              @positive_result_message = @positive_result_message << " allowing all values mentioned"
            else
              @negative_result_message = @negative_result_message << " not allowing these values: #{not_allowed_values.inspect}"
              result = false
            end
          end

          result
        end

        def description
          options_desc = []
          options_desc << " allowing these values: #{@allowed_values}" if @allowed_values
          super << options_desc.to_sentence
        end
      end

      def validate_inclusion_of(field)
        ValidateInclusionOfMatcher.new(field)
      end
    end
  end
end