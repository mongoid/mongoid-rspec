module Mongoid
  module Matchers
    def be_stored_in(options)
      BeStoredIn.new(options)
    end

    class BeStoredIn
      def initialize(expected)
        @expected_options = expected.transform_values { |v| v.to_sym rescue v }.symbolize_keys
      end

      def matches?(actual)
        @model = actual.is_a?(Class) ? actual : actual.class
        actual_options == @expected_options
      end

      def description
        "be stored in #{@expected_options.inspect}"
      end

      def failure_message
        "Expected #{@model.inspect} to #{description}, got #{actual_options.inspect}"
      end

      def failure_message_when_negated
        "Expected #{@model.inspect} not to #{description}, got #{actual_options.inspect}"
      end

      private

      def actual_options
        @actual_options ||= begin
          hash = @model.storage_options.slice(*@expected_options.keys)
          hash.each do |option, value|
            hash[option] =
              if value.is_a?(Proc)
                evaluated_value = @model.persistence_context.send("#{option}_name")
                begin
                  evaluated_value.to_sym
                rescue StandardError
                  evaluated_value
                end
              else
                begin
                  value.to_sym
                rescue StandardError
                  value
                end
              end
          end
        end
      end
    end
  end
end
