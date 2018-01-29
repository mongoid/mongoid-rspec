module Mongoid
  module Matchers
    def have_timestamps
      HaveTimestamps.new
    end

    class HaveTimestamps
      def initialize
        @root_module = 'Mongoid::Timestamps'
      end

      def matches?(actual)
        @model = actual.is_a?(Class) ? actual : actual.class
        @model.included_modules.include?(expected_module)
      end

      def for(phase)
        raise('You\'ve already declared timetamp\'s sub-module via "for" clause') if @submodule

        case @phase = phase.to_sym
        when :creating then @submodule = 'Created'
        when :updating then @submodule = 'Updated'
        else
          raise('Timestamps can be declared only for creating or updating')
        end

        self
      end

      def shortened
        @shortened = true
        self
      end

      def description
        desc = 'be a Mongoid document with'
        desc << ' shorted' if @shortened
        desc << " #{@phase}" if @phase
        desc << ' timestamps'
        desc
      end

      def failure_message
        "Expected #{@model.inspect} class to #{description}"
      end

      def failure_message_when_negated
        "Expected #{@model.inspect} class to not #{description}"
      end

      private

      def expected_module
        expected_module = @root_module
        expected_module << "::#{@submodule}" if @submodule
        expected_module << '::Short' if @shortened
        expected_module.constantize
      end
    end
  end
end
