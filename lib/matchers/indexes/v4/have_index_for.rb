module Mongoid
  module Matchers
    def have_index_for(index_key)
      HaveIndexFor.new(index_key)
    end

    class HaveIndexFor < Mongoid::Matchers::HaveIndexForBase
      def matches?(actual)
        @model = actual.is_a?(Class) ? actual : actual.class

        actual_index &&
          expected_index.key == actual_index.key &&
          expected_index.fields == actual_index.fields &&
          (expected_index.options.to_a - actual_index.options.to_a).empty?
      end

      def failure_message
        message = "Expected #{model.inspect} to #{description},"
        message << if actual_index.nil?
                     ' found no index'
                   else
                     " got #{index_description(actual_index)}"
                   end
        message
      end

      def failure_message_when_negated
        "Expected #{model.inspect} to not #{description}, got #{index_description(actual_index)}"
      end

      def description
        "have an index #{index_description(expected_index)}"
      end

      private

      def index_description(index)
        desc = index.key.inspect.to_s
        desc << " for fields #{index.fields.inspect}" if index.fields.present?
        desc << " including options #{index.options.inspect}" if index.options.present?
        desc
      end

      def expected_index
        @expected_index ||=
          Mongoid::Indexable::Specification.new(model, index_key, index_options)
      end

      def actual_index
        @actual_index ||= model.index_specification(expected_index.key)
      end
    end
  end
end
