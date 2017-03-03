module Mongoid
  module Matchers
    def be_mongoid_document
      BeMongoidDocument.new
    end

    class BeMongoidDocument
      def matches?(actual)
        @model = actual.is_a?(Class) ? actual : actual.class
        @model.included_modules.include?(Mongoid::Document)
      end

      def description
        'include Mongoid::Document'
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
