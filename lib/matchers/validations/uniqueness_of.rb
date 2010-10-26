require 'ruby-debug'

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
        end
              
        def matches?(actual)
          return false unless @result = super(actual)
          
          if [@validator.options[:scope]].flatten == @scope
            @positive_result_message = @positive_result_message << "scope to #{@validator.options[:scope]}"
          else
            @negative_result_message = @negative_result_message << "scope to #{@validator.options[:scope]}"
            @result = false
          end if @scope
          
          if @validator.options[:allow_blank] == @allow_blank
            @positive_result_message = @positive_result_message << " with blank values allowed"
          else
            @negative_result_message = @negative_result_message << " with no blank values allowed"
            @result = false
          end if @allow_blank     
          
          check_case_sensitivity if @case_insensitive
          
          @result
        end        
        
        def description
          options_desc = []
          options_desc << " scoped to #{@scope.inspect}" if @scope
          options_desc << " allowing blank values" if @allow_blank
          options_desc << " allowing case insensitive values" if @case_insensitive
          super << options_desc.to_sentence
        end
        
        private
        
        def check_case_sensitivity
          if @validator.options[:case_sensitive] == false
            @positive_result_message = @positive_result_message << " with case insensitive values"
          else
            @negative_result_message = @negative_result_message << " without case insensitive values"
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