module Mongoid
  module Matchers
    module Validations
      class ValidateLengthOfMatcher < HaveValidationMatcher
        def initialize(name)
          super(name, :length)
        end

        def with_maximum(value)
          @maximum = value
          self
        end

        def with_minimum(value)
          @minimum = value
          self
        end

        def within(value)
          @within = value
          self
        end
        alias :in :within

        def as_exactly(value)
          @is = value
          self
        end
        alias :is :as_exactly

        def matches?(actual)
          return false unless @result = super(actual)

          check_maximum if @maximum
          check_minimum if @minimum
          check_range if @within
          check_exact if @is

          @result
        end

        def description
          options_desc = []
          options_desc << " with maximum #{@maximum}" if @maximum
          options_desc << " with minimum #{@minimum}" if @minimum
          options_desc << " within range #{@within}" if @within
          options_desc << " as exactly #{@is}" if @is
          super << options_desc.to_sentence
        end

        private

        def check_maximum
          actual = @validator.options[:maximum]
          if actual == @maximum
            @positive_result_message << " with maximum of #{@maximum}"
          else
            @negative_result_message << " with maximum of #{actual}"
            @result = false
          end
        end

        def check_minimum
          actual = @validator.options[:minimum]
          if actual == @minimum
            @positive_result_message << " with minimum of #{@minimum}"
          else
            @negative_result_message << " with minimum of #{actual}"
            @result = false
          end
        end

        def check_range
          min, max = [@within.min, @within.max]
          actual = @validator.options
          if actual[:minimum] == min && actual[:maximum] == max
            @positive_result_message << " with range #{@within.inspect}"
          else
            @negative_result_message << " with range #{(actual[:minimum]..actual[:maximum]).inspect}"
            @result = false
          end
        end

        def check_exact
          actual = @validator.options[:is]
          if actual == @is
            @positive_result_message << " is exactly #{@is}"
          else
            @negative_result_message << " is exactly #{actual}"
            @result = false
          end
        end
      end

      def validate_length_of(field)
        ValidateLengthOfMatcher.new(field)
      end
    end
  end
end
