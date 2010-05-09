module Mongoid
  module Matchers
    module Validations  
      def validate_numericality_of(field)
        HaveValidationMatcher.new(field, :numericality)
      end           
    end
  end
end  