module Mongoid
  module Matchers
    module Validations  
      
      class HaveValidationMatcher
      
        def initialize(field, validation_type)
          @field = field.to_s
          @type = validation_type.to_s
        end
                
        def matches?(actual)
          @klass = actual.is_a?(Class) ? actual : actual.class
          
          @validator = @klass.validators_on(@field).detect{|v| v.kind.to_s == @type }
          
          if @validator
            @negative_result_message = @positive_result_message = "#{@type.inspect} validator on #{@field.inspect}"
          else
            @negative_result_message = "no #{@type.inspect} validator on #{@field.inspect}"
            return false
          end
          
          true
        end
        
        def failure_message_for_should  
          "Expected #{@klass.inspect} to #{description}, got #{@negative_result_message}"  
        end  
      
        def failure_message_for_should_not  
          "Expected #{@klass.inspect} to not #{description}, got #{@positive_result_message}"  
        end
        
        def description
          "validate #{@type} of #{@field.inspect}"
        end
      end     
    end
  end
end
