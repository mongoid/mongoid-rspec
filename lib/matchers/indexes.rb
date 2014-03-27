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

        if @klass.respond_to?(:index_options)
          # Mongoid 3
          unless @klass.index_options[@index_fields]
            @errors.push "no index for #{@index_fields}"
          else
            if !@options.nil? && !@options.empty?
              @options.each do |option, option_value|
                if denormalising_options(@klass.index_options[@index_fields])[option] != option_value
                  @errors.push "index for #{@index_fields.inspect} with options of #{@klass.index_options[@index_fields].inspect}"
                end
              end
            end
          end
        else
          # Mongoid 4
          unless @klass.index_specifications.map(&:key).include?(@index_fields)
            @errors.push "no index for #{@index_fields}"
          else
            if !@options.nil? && !@options.empty?
              index_options = @klass.index_specifications.select { |is| is.key == @index_fields }.first.options
              @options.each do |option, option_value|
                if index_options[option] != option_value
                  @errors.push "index for #{@index_fields.inspect} with options of #{index_options.inspect}"
                end
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

      private
        MAPPINGS = {
          dropDups: :drop_dups
        }

        def denormalising_options(opts)
          options = {}
          opts.each_pair do |option, value|
            options[MAPPINGS[option] || option] = value
          end
          options
        end
    end

    def have_index_for(index_fields)
      HaveIndexForMatcher.new(index_fields)
    end
  end
end
