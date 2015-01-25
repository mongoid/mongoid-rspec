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

        index_specifications = @klass.index_specifications.find { |is| is.key == @index_fields }
        if index_specifications
          if !@options.nil? && !@options.empty?
            index_options = normalize_options(index_specifications.options)
            @options.each do |option, option_value|
              if index_options[option] != option_value
                @errors.push "index for #{@index_fields.inspect} with options of #{index_options.inspect}"
              end
            end
          end
        else
          @errors.push "no index for #{@index_fields}"
        end

        @errors.empty?
      end

      def failure_message_for_should
        "Expected #{@klass.inspect} to #{description}, got #{@errors.to_sentence}"
      end

      def failure_message_for_should_not
        "Expected #{@klass.inspect} to not #{description}, got #{@klass.inspect} to #{description}"
      end

      alias :failure_message :failure_message_for_should
      alias :failure_message_when_negated :failure_message_for_should_not

      def description
        desc = "have an index for #{@index_fields.inspect}"
        desc << " with options of #{@options.inspect}" if @options
        desc
      end

      private
        MAPPINGS = {
          dropDups: :drop_dups,
          expireAfterSeconds: :expire_after_seconds,
          bucketSize: :bucket_size
        }

        def normalize_options(options)
          options.transform_keys do |key|
            MAPPINGS[key] || key
          end
        end
    end

    def have_index_for(index_fields)
      HaveIndexForMatcher.new(index_fields)
    end
  end
end
