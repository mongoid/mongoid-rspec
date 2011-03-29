module Mongoid
  module Matchers
    module Validations
      class ValidateNumericalityOfMatcher < HaveValidationMatcher
        def initialize(field)
          super(field, :numericality)
        end

        def greater_than(value)
          @greater_than = value
          self
        end

        def less_than(value)
          @less_than = value
          self
        end

        def matches?(actual)
          return false unless result = super(actual)

          if @greater_than
            if @validator.options[:greater_than] == @greater_than
              @positive_result_message = @positive_result_message << " checking if values are greater than #{@validator.options[:greater_than].inspect}"
            else
              @negative_result_message = @negative_result_message << " checking if values are greater than #{@validator.options[:greater_than].inspect}"
              result = false
            end
          end

          if @less_than
            if @validator.options[:less_than] == @less_than
              @positive_result_message = @positive_result_message << " checking if values are less than #{@validator.options[:less_than].inspect}"
            else
              @negative_result_message = @negative_result_message << " checking if values are less than #{@validator.options[:less_than].inspect}"
              result = false
            end
          end

          result
        end

        def description
          options_desc = []
          options_desc << " allowing values greater than #{@greater_than}" if @greater_than
          options_desc << " allowing values less than #{@less_than}" if @less_than
          super << options_desc.to_sentence
        end
      end

      def validate_numericality_of(field)
        ValidateNumericalityOfMatcher.new(field)
      end
    end
  end
end