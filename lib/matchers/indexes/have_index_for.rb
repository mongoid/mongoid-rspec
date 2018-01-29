module Mongoid
  module Matchers
    class HaveIndexForBase
      attr_reader :index_key, :index_options, :model

      def initialize(index_key)
        @index_key = index_key.symbolize_keys
      end

      def with_options(index_options = {})
        @index_options = index_options
        self
      end
    end
  end
end
