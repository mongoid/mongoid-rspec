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
        alias :less_than :with_maximum

        def with_minimum(value)
          @minimum = value
          self
        end
        alias :greater_than :with_minimum

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
          options_desc << "with minimum of #{@minimum}" if @minimum
          options_desc << "with maximum of #{@maximum}" if @maximum
          options_desc << "within the range of #{@within}" if @within
          options_desc << "as exactly #{@is}" if @is
          super << " #{options_desc.to_sentence}"
        end

        private

        def check_maximum
          if actual_max.nil?
            @negative_result_message << " with no maximum"
            @result = false
          elsif actual_max == @maximum
            @positive_result_message << " with maximum of #{@maximum}"
          else
            @negative_result_message << " with maximum of #{actual_max}"
            @result = false
          end
        end

        def check_minimum
          if actual_min.nil?
            @negative_result_message << " with no minimum"
            @result = false
          elsif actual_min == @minimum
            @positive_result_message << " with minimum of #{@minimum}"
          else
            @negative_result_message << " with minimum of #{actual_min}"
            @result = false
          end
        end

        def check_range
          min, max = [@within.min, @within.max]
          if !actual_min.nil? and actual_max.nil?
            @negative_result_message << " with no minimum but with maximum of #{actual_max}"
            @result = false
          elsif actual_min.nil? and !actual_max.nil?
            @negative_result_message << " with minimum_of #{actual_min} but no maximum"
            @result = false
          elsif actual_min.nil? and actual_max.nil?
            @negative_result_message << " with no minimum and maximum"
            @result = false
          elsif actual_min == min && actual_max == max
            @positive_result_message << " within the range of #{@within.inspect}"
          else
            @negative_result_message << " within the range of #{(actual_min..actual_max).inspect}"
            @result = false
          end
        end

        def check_exact
          if actual_is == @is
            @positive_result_message << " as exactly #{@is}"
          else
            @negative_result_message << " as exactly #{actual_is}"
            @result = false
          end
        end

        def actual_is
          actual_is = @validator.options[:is]
        end

        def actual_min
          @validator.options[:minimum] || ((@validator.options[:in] || @validator.options[:within]).try(&:min))
        end

        def actual_max
          @validator.options[:maximum] || ((@validator.options[:in] || @validator.options[:within]).try(&:max))
        end
      end

      def validate_length_of(field)
        ValidateLengthOfMatcher.new(field)
      end
    end
  end
end
