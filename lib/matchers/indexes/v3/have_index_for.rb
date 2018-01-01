module Mongoid
  module Matchers

    def have_index_for(index_key)
      HaveIndexFor.new(index_key)
    end

    class HaveIndexFor < Mongoid::Matchers::Base::HaveIndexFor

      def matches?(klass)
        @klass  = klass.is_a?(Class) ? klass : klass.class
        @errors = []

        if @klass.respond_to?(:index_options)
          # Mongoid 3
          unless @klass.index_options[@index_key]
            @errors.push "no index for #{@index_key}"
          else
            if !@index_options.nil? && !@index_options.empty?
              @index_options.each do |option, option_value|
                if denormalising_options(@klass.index_options[@index_key])[option] != option_value
                  @errors.push "index for #{@index_key.inspect} with options of #{@klass.index_options[@index_key].inspect}"
                end
              end
            end
          end
        else
          # Mongoid 4
          unless @klass.index_specifications.map(&:key).include?(@index_key)
            @errors.push "no index for #{@index_key}"
          else
            if !@index_options.nil? && !@index_options.empty?
              index_options = @klass.index_specifications.select { |is| is.key == @index_key }.first.options
              @index_options.each do |option, option_value|
                if index_options[option] != option_value
                  @errors.push "index for #{@index_key.inspect} with options of #{index_options.inspect}"
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

      alias :failure_message :failure_message_for_should
      alias :failure_message_when_negated :failure_message_for_should_not

      def description
        desc = "have an index for #{@index_key.inspect}"
        desc << " with options of #{@index_options.inspect}" if @index_options
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
    # Class Ends here
  end
end