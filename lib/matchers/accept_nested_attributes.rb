module Mongoid
  module Matchers # :nodoc:

    # Ensures that the model can accept nested attributes for the specified
    # association.
    #
    # Example:
    #   it { should accept_nested_attributes_for(:articles) }
    #
    def accept_nested_attributes_for(attribute)
      AcceptNestedAttributesForMatcher.new(attribute)
    end

    class AcceptNestedAttributesForMatcher

      def initialize(attribute)
        @attribute = attribute.to_s
        @options = {}
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
      end

      protected
        def match?
          exists?
        end

        def exists?
          if config
            true
          else
            @problem = 'is not declared'
            false
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
    end
  end
end