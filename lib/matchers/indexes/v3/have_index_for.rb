module Mongoid
  module Matchers
    def have_index_for(index_key)
      HaveIndexFor.new(index_key)
    end

    class HaveIndexFor < Mongoid::Matchers::HaveIndexForBase
      def matches?(klass)
        @model  = klass.is_a?(Class) ? klass : klass.class
        @errors = []

        if model.index_options[index_key]
          if !index_options.nil? && !index_options.empty?
            index_options.each do |option, option_value|
              if denormalising_options(model.index_options[index_key])[option] != option_value
                @errors.push "index for #{index_key.inspect} with options of #{model.index_options[index_key].inspect}"
              end
            end
          end
        else
          @errors.push "no index for #{index_key}"
        end

        @errors.empty?
      end

      def failure_message_for_should
        "Expected #{model.inspect} to #{description}, got #{@errors.to_sentence}"
      end

      def failure_message_for_should_not
        "Expected #{model.inspect} to not #{description}, got #{model.inspect} to #{description}"
      end

      alias failure_message failure_message_for_should
      alias failure_message_when_negated failure_message_for_should_not

      def description
        desc = "have an index for #{index_key.inspect}"
        desc << " with options of #{index_options.inspect}" if index_options
        desc
      end

      private

      MAPPINGS = {
        dropDups: :drop_dups # Deprecated from MongoDB 3.0
      }.freeze

      def denormalising_options(opts)
        options = {}
        opts.each_pair do |option, value|
          options[MAPPINGS[option] || option] = value
        end
        options
      end
    end
  end
end
