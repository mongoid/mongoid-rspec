if Mongoid::Compatibility::Version.mongoid4_or_newer?
  module Mongoid
    module Matchers
      module Validations
        def validate_absence_of(field)
          HaveValidationMatcher.new(field, :absence)
        end
      end
    end
  end
end
