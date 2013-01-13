module Mongoid
  module Matchers
    class HaveFieldMatcher # :nodoc:
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
            error = ""
            if @type and @klass.fields[attr].type != @type
              error << " of type #{@klass.fields[attr].type}"
            end

            if !@default.nil?
              if @klass.fields[attr].default_val.nil?
                error << " with default not set"
              elsif @klass.fields[attr].default_val != @default
                error << " with default value of #{@klass.fields[attr].default_val}"
              end
            end

            if @field_alias and @klass.fields[attr].options[:as] != @field_alias
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

      def description
        desc = "have #{@attributes.size > 1 ? 'fields' : 'field'} named #{@attributes.collect(&:inspect).to_sentence}"
        desc << " of type #{@type.inspect}" if @type
        desc << " with alias #{@field_alias}" if @field_alias
        desc << " with default value of #{@default.inspect}" if !@default.nil?
        desc
      end
    end

    def have_field(*args)
      HaveFieldMatcher.new(*args)
    end
    alias_method :have_fields, :have_field
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
    doc.class.included_modules.include?(Mongoid::Document)
  end

  description do
    "be a Mongoid document"
  end
end

RSpec::Matchers.define :be_versioned_document do
  match do |doc|
    doc.class.included_modules.include?(Mongoid::Versioning)
  end

  description do
    "be a versioned Mongoid document"
  end
end

RSpec::Matchers.define :be_timestamped_document do
  match do |doc|
    if [*@timestamped_module].any?
      modules = [*@timestamped_module].map{|m| "Mongoid::Timestamps::#{m.to_s.classify}".constantize }
      (modules - doc.class.included_modules).empty?
    else
      doc.class.included_modules.include?(Mongoid::Timestamps) or
      doc.class.included_modules.include?(Mongoid::Timestamps::Created) or
      doc.class.included_modules.include?(Mongoid::Timestamps::Updated)
    end
  end

  chain :with do |timestamped_module|
    @timestamped_module = timestamped_module
  end

  description do
    desc = "be a timestamped Mongoid document"
    desc << " with #{@timestamped_module}" if @timestamped_module
    desc
  end
end

RSpec::Matchers.define :be_paranoid_document do
  match do |doc|
    doc.class.included_modules.include?(Mongoid::Paranoia)
  end

  description do
    "be a paranoid Mongoid document"
  end
end

RSpec::Matchers.define :be_multiparameted_document do
  match do |doc|
    doc.class.included_modules.include?(Mongoid::MultiParameterAttributes)
  end

  description do
    "be a multiparameted Mongoid document"
  end
end
