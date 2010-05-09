module Mongoid
  module Matchers
    module Validations  
      class ValidateAssociatedMatcher < HaveValidationMatcher
        def initialize(name)
          super(name, :associated)
        end
        
        def description
          "validate associated #{@field.inspect}"
        end
      end
      
      def validate_associated(association_name)
        ValidateAssociatedMatcher.new(association_name)
      end           
    end
  end
end  