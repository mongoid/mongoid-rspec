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

          @validator = @klass.validators_on(@field).detect{|v| v.kind.to_s == @type}

          if @validator
            @negative_result_message = "#{@type.inspect} validator on #{@field.inspect}"
            @positive_result_message = "#{@type.inspect} validator on #{@field.inspect}"
          else
            @negative_result_message = "no #{@type.inspect} validator on #{@field.inspect}"
            return false
          end
          @result = true
          check_on if @options[:on]
          @result
        end

        def failure_message_for_should
          "Expected #{@klass.inspect} to #{description}; instead got #{@negative_result_message}"
        end

        def failure_message_for_should_not
          "Expected #{@klass.inspect} to not #{description}; instead got #{@positive_result_message}"
        end

        def description
          desc = "have #{@type.inspect} validator on #{@field.inspect}"
          desc << " on #{@options[:on]}" if @options[:on]
          desc
        end

        def on(*on_method)
          @options[:on] = on_method.flatten
          self
        end

        def check_on
          validator_on_methods = [@validator.options[:on]].flatten

          if validator_on_methods.any?
            message = " on methods: #{validator_on_methods}"

            if (@options[:on] - validator_on_methods).empty?
              @positive_result_message << message
            else
              @negative_result_message << message
              @result = false
            end
          end
        end
      end
    end
  end
end
