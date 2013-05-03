module Mongoid
  module Matchers
    module Validations
      module WithMessage
        def with_message(message)
          @expected_message = message
          self
        end

        private

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
    end
  end
end
