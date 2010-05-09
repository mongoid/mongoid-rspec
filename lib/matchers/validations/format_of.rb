module Mongoid
  module Matchers
    module Validations  
      class ValidateFormatOfMatcher < HaveValidationMatcher
        def initialize(field)
          super(field, :format)
        end
        
        def with_format(format)
          @format = format
          self
        end
        
        def to_allow(valid_value)
          @valid_value = valid_value
          self          
        end
        
        def not_to_allow(invalid_value)
          @invalid_value = invalid_value
          self          
        end
        
        def matches?(actual)
          return false unless result = super(actual)
          
          if @format
            if @validator.options[:with] == @format
              @positive_result_message = @positive_result_message << " with format #{@validator.options[:format].inspect}"
            else
              @negative_result_message = @negative_result_message << " with format #{@validator.options[:format].inspect}"
              result = false
            end 
          end
          
          if @valid_value
            if @validator.options[:with] =~ @valid_value
              @positive_result_message = @positive_result_message << " with #{@valid_value.inspect} as a valid value"
            else
              @negative_result_message = @negative_result_message << " with #{@valid_value.inspect} as an invalid value"
              result = false
            end 
          end
          
          if @invalid_value  
            if !(@invalid_value =~ @validator.options[:with])
              @positive_result_message = @positive_result_message << " with #{@invalid_value.inspect} as an invalid value"
            else
              @negative_result_message = @negative_result_message << " with #{@invalid_value.inspect} as a valid value"
              result = false
            end 
          end
          
          result          
        end
        
        def description
          options_desc = []
          options_desc << " with format #{@format.inspect}" if @format
          options_desc << " allowing the value #{@valid_value.inspect}" if @valid_value
          options_desc << " not allowing the value #{@invalid_value.inspect}" if @invalid_value                    
          super << options_desc.to_sentence
        end        
      end

      def validate_format_of(field)
        ValidateFormatOfMatcher.new(field)
      end           
    end
  end
end  