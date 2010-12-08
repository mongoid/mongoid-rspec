module Mongoid
  module Matchers
    module Validations
      class ValidateLengthOfMatcher < HaveValidationMatcher
        def initialize(field)
          super(field, :length)
        end

        def within(range)
          @within = range
          self
        end

        def matches?(actual)
          return false unless result = super(actual)

          if @within
            if @validator.options[:minimum] == @within.min
              @positive_result_message = @positive_result_message << " checking if longer than #{@validator.options[:minimum].inspect}"
            else
              @negative_result_message = @negative_result_message << " checking if longer than #{@validator.options[:minimum].inspect}"
              result = false
            end

            if @validator.options[:maximum] == @within.max
              @positive_result_message = @positive_result_message << " checking if shorter than #{@validator.options[:maximum].inspect}"
            else
              @negative_result_message = @negative_result_message << " checking if shorter than #{@validator.options[:maximum].inspect}"
              result = false
            end
          end

          result
        end

        def description
          options_desc = []
          options_desc << " in range #{@within}" if @within
          super << options_desc.to_sentence
        end
      end

      def validate_length_of(field)
        ValidateLengthOfMatcher.new(field)
      end
    end
  end
end