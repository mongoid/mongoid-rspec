module Mongoid
  module Matchers
    module Validations  
      class ValidateUniquenessOfMatcher < HaveValidationMatcher
        def initialize(field)
          super(field, :uniqueness)
        end
        
        def scoped_to(*scope)
          @scope = [scope].flatten
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
          
          if [@validator.options[:scope]].flatten == @scope
            @positive_result_message = @positive_result_message << "scope to #{@validator.options[:scope]}"
          else
            @negative_result_message = @negative_result_message << "scope to #{@validator.options[:scope]}"
          end if @scope
          
          if @validator.options[:allow_blank] == @allow_blank
            @positive_result_message = @positive_result_message << " with blank values allowed"
          else
            @negative_result_message = @negative_result_message << " with no blank values allowed"
          end if @allow_blank
          
          check_case_sensitivity if @case_insensitive

          check_expected_message if @expected_message
          
          finished_result
        end

        def description
          options_desc = []
          options_desc << " scoped to #{@scope.inspect}" if @scope
          options_desc << " allowing blank values" if @allow_blank
          options_desc << " allowing case insensitive values" if @case_insensitive
          options_desc << " with message '#{@expected_message}'" if @case_insensitive
          super << options_desc.to_sentence
        end
        
        private

        def finished_result
          !@negative_result_message.blank?
        end
        
        def check_case_sensitivity
          if @validator.options[:case_sensitive] == false
            @positive_result_message = @positive_result_message << " with case insensitive values"
          else
            @negative_result_message = @negative_result_message << " without case insensitive values"
          end
        end

        def check_expected_message
          actual_message = @validator.options[:message]
          if actual_message.nil?
            @negative_result_message = @negative_result_message << " with no custom message"
          elsif actual_message == @expected_message
            @positive_result_message = @positive_result_message << " with custom message '#{@expected_message}'"
          else
            @negative_result_message = @negative_result_message << " got message '#{actual_message}'"
          end
        end
      end
      
      def validate_uniqueness_of(field)
        ValidateUniquenessOfMatcher.new(field)
      end       
    end
  end
end  