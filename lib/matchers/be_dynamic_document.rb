module Mongoid
  module Matchers
    def be_dynamic_document
      BeDynamicDocument.new
    end

    class BeDynamicDocument
      def matches?(actual)
        @model = actual.is_a?(Class) ? actual : actual.class
        @model.included_modules.include?(Mongoid::Attributes::Dynamic)
      end

      def description
        'include Mongoid::Attributes::Dynamic'
      end

      def failure_message
        "expect #{@model.inspect} class to #{description}"
      end

      def failure_message_when_negated
        "expect #{@model.inspect} class to not #{description}"
      end
    end
  end
end
