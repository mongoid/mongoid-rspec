module Mongoid
  module Matchers
    module Validations
      class HaveValidationMatcher
        def initialize(field, validation_type)
          @field = field.to_s
          @type = validation_type.to_s
          @options = {}
        end

        def matches?(actual)
          @klass = actual.is_a?(Class) ? actual : actual.class

          @validator = @klass.validators_on(@field).detect do |v|
            (v.kind.to_s == @type) && (!v.options[:on] || on_options_matches?(v)) &&
              if_condition_matches?(actual, v) && unless_condition_matches?(actual, v)
          end

          if @validator
            @negative_result_message = "#{@type.inspect} validator on #{@field.inspect}"
            @positive_result_message = "#{@type.inspect} validator on #{@field.inspect}"
          else
            @negative_result_message = "no #{@type.inspect} validator on #{@field.inspect}"
            return false
          end
          @result = true
          check_on if @options[:on]
          check_expected_message if @expected_message
          @result
        end

        def failure_message_for_should
          "Expected #{@klass.inspect} to #{description}; instead got #{@negative_result_message}"
        end

        def failure_message_for_should_not
          "Expected #{@klass.inspect} to not #{description}; instead got #{@positive_result_message}"
        end

        alias failure_message failure_message_for_should
        alias failure_message_when_negated failure_message_for_should_not

        def description
          desc = "have #{@type.inspect} validator on #{@field.inspect}"
          desc << " on #{@options[:on]}" if @options[:on]
          desc << " with message #{@expected_message.inspect}" if @expected_message

          desc
        end

        def on(*on_method)
          @options[:on] = on_method.flatten
          self
        end

        def with_message(message)
          @expected_message = message
          self
        end

        private

        def if_condition_matches?(actual, validator)
          return true unless validator.options[:if]

          check_condition actual, validator.options[:if]
        end

        def unless_condition_matches?(actual, validator)
          return true unless validator.options[:unless]

          !check_condition actual, validator.options[:unless]
        end

        def check_condition(actual, filter)
          raise ArgumentError, 'Spec subject must be object instance when testing validators with if/unless condition.' if actual.is_a?(Class)

          case filter
          when Symbol
            actual.send filter
          when ::Proc
            actual.instance_exec(&filter)
          else
            raise ArgumentError, "Unexpected filter: #{filter.inspect}"
          end
        end

        def check_on
          validator_on_methods = [@validator.options[:on]].flatten

          if validator_on_methods.any?
            message = " on methods: #{validator_on_methods}"

            if on_options_covered_by?(@validator)
              @positive_result_message << message
            else
              @negative_result_message << message
              @result = false
            end
          end
        end

        def on_options_matches?(validator)
          @options[:on] && validator.options[:on] && on_options_covered_by?(validator)
        end

        def on_options_covered_by?(validator)
          ([@options[:on]].flatten - [validator.options[:on]].flatten).empty?
        end

        def check_expected_message
          actual_message = @validator.options[:message]
          if actual_message.nil?
            @negative_result_message << ' with no custom message'
            @result = false
          elsif actual_message == @expected_message
            @positive_result_message << " with custom message '#{@expected_message}'"
          else
            @negative_result_message << " got message '#{actual_message}'"
            @result = false
          end
        end
      end
    end
  end
end
