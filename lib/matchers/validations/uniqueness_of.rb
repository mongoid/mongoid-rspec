# frozen_string_literal: true

module Mongoid
  module Matchers
    module Validations
      class ValidateUniquenessOfMatcher < HaveValidationMatcher
        def initialize(field)
          super(field, :uniqueness)
        end

        def scoped_to(*scope)
          @scope = [scope].flatten.map(&:to_sym)
          self
        end
        alias scoped_on scoped_to

        def case_insensitive
          @case_insensitive = true
          self
        end

        def allow_blank?(allow_blank)
          @allow_blank = allow_blank
          self
        end

        def description
          options_desc = []
          options_desc << " scoped to #{@scope.inspect}" if @scope
          options_desc << ' allowing blank values' if @allow_blank
          options_desc << ' allowing case insensitive values' if @case_insensitive
          super << options_desc.to_sentence
        end

        private

        def check_validator(actual, validator)
          return false unless @result = super

          check_scope(validator) if @scope
          check_allow_blank(validator) if @allow_blank
          check_case_sensitivity(validator) if @case_insensitive

          @result
        end

        def check_allow_blank(validator)
          if validator.options[:allow_blank] == @allow_blank
            @positive_result_message << ' with blank values allowed'
          else
            @negative_result_message << ' with no blank values allowed'
            @result = false
          end
        end

        def check_scope(validator)
          message = " scope to #{validator.options[:scope]}"
          if [validator.options[:scope]].flatten.map(&:to_sym) == @scope
            @positive_result_message << message
          else
            @negative_result_message << message
            @result = false
          end
        end

        def check_case_sensitivity(validator)
          if validator.options[:case_sensitive] == false
            @positive_result_message << ' with case insensitive values'
          else
            @negative_result_message << ' without case insensitive values'
            @result = false
          end
        end
      end

      def validate_uniqueness_of(field)
        ValidateUniquenessOfMatcher.new(field)
      end
    end
  end
end
