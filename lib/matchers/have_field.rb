module Mongoid
  module Matchers
    class HaveField # :nodoc:
      def initialize(*attrs)
        @attributes = attrs.collect(&:to_s)
      end

      def localized
        @localized = true
        self
      end

      def of_type(type)
        @type = type
        self
      end

      def with_alias(field_alias)
        @field_alias = field_alias
        self
      end

      def with_default_value_of(default)
        @default = default
        self
      end

      def matches?(klass)
        @klass = klass.is_a?(Class) ? klass : klass.class
        @errors = []
        @attributes.each do |attr|
          if @klass.fields.include?(attr)
            error = ''
            if @type && (@klass.fields[attr].type != @type)
              error << " of type #{@klass.fields[attr].type}"
            end

            unless @default.nil?
              if @klass.fields[attr].default_val.nil?
                error << ' with default not set'
              elsif @klass.fields[attr].default_val != @default
                error << " with default value of #{@klass.fields[attr].default_val}"
              end
            end

            if @field_alias && (@klass.fields[attr].options[:as] != @field_alias)
              error << " with alias #{@klass.fields[attr].options[:as]}"
            end

            @errors.push("field #{attr.inspect}" << error) unless error.blank?

            if @localized
              unless @klass.fields[attr].localized?
                @errors.push "is not localized #{attr.inspect}"
              end
            end

          else
            @errors.push "no field named #{attr.inspect}"
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

      alias failure_message failure_message_for_should
      alias failure_message_when_negated failure_message_for_should_not

      def description
        desc = "have #{@attributes.size > 1 ? 'fields' : 'field'} named #{@attributes.collect(&:inspect).to_sentence}"
        desc << " of type #{@type.inspect}" if @type
        desc << " with alias #{@field_alias}" if @field_alias
        desc << " with default value of #{@default.inspect}" unless @default.nil?
        desc
      end
    end

    def have_field(*args)
      HaveField.new(*args)
    end
    alias have_fields have_field
  end
end
