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
        alias_method :scoped_on, :scoped_to
        
        def case_insensitive
          @case_insensitive = true
          self
        end
        
        def allow_blank?(allow_blank)
          @allow_blank = allow_blank
          self
        end

        def with_message(message)
          @expected_message = message
          self
        end

        def matches?(actual)
          return false unless @result = super(actual)
          
          check_scope if @scope
          check_allow_blank if @allow_blank
          check_case_sensitivity if @case_insensitive
          check_expected_message if @expected_message
          
          @result
        end

        def description
          options_desc = []
          options_desc << " scoped to #{@scope.inspect}" if @scope
          options_desc << " allowing blank values" if @allow_blank
          options_desc << " allowing case insensitive values" if @case_insensitive
          options_desc << " with message '#{@expected_message}'" if @expected_message
          super << options_desc.to_sentence
        end
        
        private

        def check_allow_blank
          if @validator.options[:allow_blank] == @allow_blank
            @positive_result_message << " with blank values allowed"
          else
            @negative_result_message << " with no blank values allowed"
            @result = false
          end
        end

        def check_scope
          message = " scope to #{@validator.options[:scope]}"
          if [@validator.options[:scope]].flatten.map(&:to_sym) == @scope
            @positive_result_message << message
          else
            @negative_result_message << message
            @result = false
          end
        end
        
        def check_case_sensitivity
          if @validator.options[:case_sensitive] == false
            @positive_result_message << " with case insensitive values"
          else
            @negative_result_message << " without case insensitive values"
            @result = false
          end
        end

        def check_expected_message
          actual_message = @validator.options[:message]
          if actual_message.nil?
            @negative_result_message << " with no custom message"
            @result = false
          elsif actual_message == @expected_message
            @positive_result_message << " with custom message '#{@expected_message}'"
          else
            @negative_result_message << " got message '#{actual_message}'"
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