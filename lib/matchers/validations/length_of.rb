# frozen_string_literal: true

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
        alias less_than with_maximum

        def with_minimum(value)
          @minimum = value
          self
        end
        alias greater_than with_minimum

        def within(value)
          @within = value
          self
        end
        alias in within

        def as_exactly(value)
          @is = value
          self
        end
        alias is as_exactly

        def description
          options_desc = []
          options_desc << "with minimum of #{@minimum}" if @minimum
          options_desc << "with maximum of #{@maximum}" if @maximum
          options_desc << "within the range of #{@within}" if @within
          options_desc << "as exactly #{@is}" if @is
          super << " #{options_desc.to_sentence}"
        end

        private

        def check_validator(actual, validator)
          return false unless @result = super

          check_maximum(validator) if @maximum
          check_minimum(validator) if @minimum
          check_range(validator) if @within
          check_exact(validator) if @is

          @result
        end

        def select_validator(validators)
          validators.detect do |validator|
            (!@minimum || actual_min(validator) == @minimum) &&
              (!@maximum || actual_max(validator) == @maximum) &&
              (!@within || @within.minmax == [actual_min(validator), actual_max(validator)]) &&
              (!@is || validator.options[:is] == @is) &&
              (!@expected_message || validator.options[:message] == @expected_message)
          end || super
        end

        def check_maximum(validator)
          maximum = actual_max(validator)
          if maximum.nil?
            @negative_result_message << ' with no maximum'
            @result = false
          elsif maximum == @maximum
            @positive_result_message << " with maximum of #{@maximum}"
          else
            @negative_result_message << " with maximum of #{maximum}"
            @result = false
          end
        end

        def check_minimum(validator)
          minimum = actual_min(validator)
          if minimum.nil?
            @negative_result_message << ' with no minimum'
            @result = false
          elsif minimum == @minimum
            @positive_result_message << " with minimum of #{@minimum}"
          else
            @negative_result_message << " with minimum of #{minimum}"
            @result = false
          end
        end

        def check_range(validator)
          min, max = @within.minmax
          minimum = actual_min(validator)
          maximum = actual_max(validator)
          if !minimum.nil? && maximum.nil?
            @negative_result_message << " with no minimum but with maximum of #{maximum}"
            @result = false
          elsif minimum.nil? && !maximum.nil?
            @negative_result_message << " with minimum_of #{minimum} but no maximum"
            @result = false
          elsif minimum.nil? && maximum.nil?
            @negative_result_message << ' with no minimum and maximum'
            @result = false
          elsif minimum == min && maximum == max
            @positive_result_message << " within the range of #{@within.inspect}"
          else
            @negative_result_message << " within the range of #{(minimum..maximum).inspect}"
            @result = false
          end
        end

        def check_exact(validator)
          actual_is = validator.options[:is]
          if actual_is == @is
            @positive_result_message << " as exactly #{@is}"
          else
            @negative_result_message << " as exactly #{actual_is}"
            @result = false
          end
        end

        def actual_min(validator)
          validator.options[:minimum] || (validator.options[:in] || validator.options[:within]).try(&:min)
        end

        def actual_max(validator)
          validator.options[:maximum] || (validator.options[:in] || validator.options[:within]).try(&:max)
        end
      end

      def validate_length_of(field)
        ValidateLengthOfMatcher.new(field)
      end
    end
  end
end
