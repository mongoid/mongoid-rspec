module Mongoid
  module Matchers
    class HaveFieldMatcher # :nodoc:
      def initialize(*attrs)
        @attributes = attrs.collect(&:to_s)
      end

      def of_type(type)
        @type = type
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
            error = ""
            if @type and @klass.fields[attr].type != @type
              error << " of type #{@klass.fields[attr].type}"
            end

            if @default and @klass.fields[attr].default != @default
              error << " with default value of #{@klass.fields[attr].default}"
            end

            @errors.push("field #{attr.inspect}" << error) unless error.blank?
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

      def description
        desc = "have #{@attributes.size > 1 ? 'fields' : 'field'} named #{@attributes.collect(&:inspect).to_sentence}"
        desc << " of type #{@type.inspect}" if @type
        desc << " with default value of #{@default.inspect}" if @default
        desc
      end
    end

    def have_field(*args)
      HaveFieldMatcher.new(*args)
    end
    alias_method :have_fields, :have_field

    class SaveMatcher
      def initialize(attributes = {})
        @attributes = attributes
      end

      def matches?(actual)
        @actual = actual.is_a?(Class) ?
          ( defined?(::Factory) ? ::Factory.build(actual.name.underscore, @attributes) : actual.new(@attributes)) :
          actual
        @actual.valid? and @actual.save
      end

      def failure_message_for_should
        "Expected #{@actual.inspect} to save properly, got #{@actual.errors.full_messages.to_sentence}"
      end

      def failure_message_for_should_not
        "Expected #{@actual.inspect} to not save, got saved instead"
      end

      def description
        "save properly"
      end
    end

    def save(attributes = {})
      SaveMatcher.new(attributes)
    end
    alias_method :save_properly, :save

  end
end

RSpec::Matchers.define :have_instance_method do |name|
  match do |klass|
    klass.instance_methods.include?(name.to_sym)
  end

  description do
    "have instance method #{name.to_s}"
  end
end

RSpec::Matchers.define :be_mongoid_document do
  match do |doc|
    doc.class.included_modules.should include(Mongoid::Document)
  end
end

RSpec::Matchers.define :be_versioned_document do
  match do |doc|
    doc.class.included_modules.should include(Mongoid::Versioning)
  end
end

RSpec::Matchers.define :be_timestamped_document do
  match do |doc|
    doc.class.included_modules.should include(Mongoid::Timestamps)
  end
end

RSpec::Matchers.define :be_paranoid_document do
  match do |doc|
    doc.class.included_modules.should include(Mongoid::Paranoia)
  end
end
