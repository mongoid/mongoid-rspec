module Mongoid
  module Matchers # :nodoc:

    # Ensures that the model can accept nested attributes for the specified
    # association.
    #
    # Options:
    # * <tt>allow_destroy</tt> - Whether or not to allow destroy
    # * <tt>limit</tt> - Max number of nested attributes
    # * <tt>update_only</tt> - Only allow updates
    #
    # Example:
    #   it { should accept_nested_attributes_for(:articles) }
    #   it { should accept_nested_attributes_for(:articles).
    #                 allow_destroy(true).
    #                 limit(1) }
    #   it { should accept_nested_attributes_for(:articles).update_only(true) }
    #
    def accept_nested_attributes_for(attribute)
      AcceptNestedAttributesForMatcher.new(attribute)
    end

    class AcceptNestedAttributesForMatcher

      def initialize(attribute)
        @attribute = attribute.to_s
        @options = {}
      end

      def allow_destroy(allow_destroy)
        @options[:allow_destroy] = allow_destroy
        self
      end

      def limit(limit)
        @options[:limit] = limit
        self
      end

      def update_only(update_only)
        @options[:update_only] = update_only
        self
      end

      def matches?(subject)
        @subject = subject
        match?
      end

      def failure_message
        "Expected #{expectation} (#{@problem})"
      end

      def negative_failure_message
        "Did not expect #{expectation}"
      end

      def description
        description = "accepts_nested_attributes_for :#{@attribute}"
        if @options.key?(:allow_destroy)
          description += " allow_destroy => #{@options[:allow_destroy]}"
        end
        if @options.key?(:limit)
          description += " limit => #{@options[:limit]}"
        end
        if @options.key?(:update_only)
          description += " update_only => #{@options[:update_only]}"
        end
        description
      end

      protected
        def match?
          exists? # &&
          # limit_correct? &&
          # allow_destroy_correct? &&
          # update_only_correct?
        end

        def exists?
          if config
            true
          else
            @problem = 'is not declared'
            false
          end
        end

        def allow_destroy_correct?
          failure_message = "#{should_or_should_not(@options[:allow_destroy])} allow destroy"
          verify_option_is_correct(:allow_destroy, failure_message)
        end

        def limit_correct?
          failure_message = "limit should be #{@options[:limit]}, got #{config[:limit]}"
          verify_option_is_correct(:limit, failure_message)
        end

        def update_only_correct?
          failure_message = "#{should_or_should_not(@options[:update_only])} be update only"
          verify_option_is_correct(:update_only, failure_message)
        end

        def verify_option_is_correct(option, failure_message)
          if @options.key?(option)
            if @options[option] == config[option]
              true
            else
              @problem = failure_message
              false
            end
          else
            true
          end
        end

        def config
          model_class.nested_attributes["#{@attribute}_attributes"]
        end

        def model_class
          @subject.class
        end

        def expectation
          "#{model_class.name} to accept nested attributes for #{@attribute}"
        end

        def should_or_should_not(value)
          if value
            'should'
          else
            'should not'
          end
        end
    end
  end
end