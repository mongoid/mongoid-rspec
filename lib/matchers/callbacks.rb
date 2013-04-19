module Mongoid
  module Matchers
    class HaveCallbackMatcher
      KINDS = %w[ before around after ]

      def initialize( *args )
        @methods = args || []
      end

      def matches?( klass )
        return false unless @kind

        @methods.each do |method|
          filters = klass.class.send( "_#{@operation}_callbacks".to_sym ).select do |c|
            c.filter == method && c.kind == @kind && c.options[:on] == @on
          end
          return false if filters.empty?
        end
      end

      KINDS.each do |kind|
        define_method( kind.to_sym ) do |op|
          @operation = op
          @kind = kind.to_sym
          self
        end
      end

      def on( action )
        @on = action
        self
      end

      def failure_message_for_should
        failure_message( true )
      end

      def failure_message_for_should_not
        failure_message( false )
      end

      def description
        msg = "call #{@methods.join(", ")}"
        msg << " #{@kind} #{@operation}" if @operation
        msg << " on #{@on}" if @on
        msg
      end

      protected
      def failure_message( should )
        if @kind
          msg = "Expected method#{@methods.size > 1 ? 's' : ''} #{@methods.join(", ")} #{should ? '' : 'not ' }to be called"
          msg << " #{@kind} #{@operation}" if @operation
          msg << " on #{@on}" if @on
          msg
        else
          "Callback#{@methods.size > 1 ? 's' : '' } #{@methods.join(", ")} can"\
          "not be tested against undefined lifecycle. Use .before, .after or .around"
        end
      end

    end

    def callback( *args )
      HaveCallbackMatcher.new( *args )
    end
  end
end
