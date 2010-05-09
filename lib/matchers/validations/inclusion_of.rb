module Mongoid
  module Matchers
    module Validations  
      class ValidateInclusionOfMatcher < HaveValidationMatcher
        def initialize(name)
          super(name, :inclusion)
        end
        
        def to_allow(*values)
          @allowed_values = [values].flatten
          self
        end
        
        def matches?(actual)
          return false unless result = super(actual)
          
          if @allowed_values
            not_allowed_values = @allowed_values - @validator.options[:in]
            if not_allowed_values.empty?
              @positive_result_message = @positive_result_message << " allowing all values mentioned"
            else
              @negative_result_message = @negative_result_message << " not allowing the following the ff. values: #{not_allowed_values.inspect}"
              result = false
            end
          end
          
          result          
        end
        
        def description
          options_desc = []
          options_desc << " allowing the ff. values: #{@allowed_values}" if @allowed_values                
          super << options_desc.to_sentence
        end 
      end

      def validate_inclusion_of(field)
        ValidateInclusionOfMatcher.new(field)
      end       
    end
  end
end  