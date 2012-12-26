module Mongoid
  module Matchers
    class HaveIndexForMatcher # :nodoc:
      def initialize(index_fields)
        @index_fields = index_fields.symbolize_keys!
      end

      def with_options(options = { })
        @options = options
        self
      end

      def matches?(klass)
        @klass  = klass.is_a?(Class) ? klass : klass.class
        @errors = []

        unless @klass.index_options[@index_fields]
          @errors.push "no index for #{@index_fields}"
        else
          if !@options.nil? && !@options.empty?
            @options.each do |option, option_value|
              if @klass.index_options[@index_fields][option] != option_value
                @errors.push "index for #{@index_fields.inspect} with options of #{@klass.index_options[@index_fields].inspect}"
              end
            end
          end
        end

        @errors.empty?
      end

      def failure_message_for_should
        "Expected #{@klass.inspect} to #{description}, got #{@errors.to_sentence}"
      end

      def failure_message_for_should_not
        "Expected #{@klass.inspect} to not #{description}, got #{@klass.inspect} to #{description}"
      end

      def description
        desc = "have an index for #{@index_fields.inspect}"
        desc << " with options of #{@options.inspect}" if @options
        desc
      end
    end
    
    def have_index_for(index_fields)
      HaveIndexForMatcher.new(index_fields)
    end
  end
end
