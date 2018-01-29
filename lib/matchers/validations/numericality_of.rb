module Mongoid
  module Matchers
    module Validations
      class ValidateNumericalityOfMatcher < HaveValidationMatcher
        ALLOWED_OPTIONS =
          %i[
            allow_nil
            equal_to
            even
            greater_than
            greater_than_or_equal_to
            less_than
            less_than_or_equal_to
            nil
            odd
            only_integer
          ].freeze

        def initialize(field)
          super(field, :numericality)
          @options = {}
        end

        def to_allow(options)
          options[:equal_to] = options if options.is_a?(Numeric)
          options[:allow_nil] = options.delete(:nil) if options.key?(:nil)

          if !options.is_a?(Hash) || options.empty? || (options.keys - ALLOWED_OPTIONS).any?
            message =
              'validate_numericality_of#to_allow requires a Hash parameter containing' \
              "any of the following keys: #{ALLOWED_OPTIONS.map(&:inspect).join(', ')}"
            raise ArgumentError, message
          end

          @options.merge!(options)
          self
        end

        def matches?(actual)
          return false unless result = super(actual)

          @options.each do |comparator, expected_value|
            result &= (@validator.options[comparator] == expected_value)
          end

          @positive_result_message <<= options_message(@validator.options)
          @negative_result_message <<= options_message(@validator.options)
          result
        end

        def description
          super << options_message(@options)
        end

        protected

        def options_message(options)
          type_msg = []
          comp_msg = []
          options.each_pair do |key, value|
            case key
            when :allow_nil
            when :only_integer
              type_msg << 'integer' if value
            when :odd, :even
              type_msg << "#{key}-numbered" if value
            else
              comp_msg << "#{key.to_s.tr('_', ' ')} #{value.inspect}"
            end
          end
          allow_nil = (options[:allow_nil] ? 'nil' : 'non-nil') if options.key?(:allow_nil)
          ['', 'allowing', allow_nil, type_msg.any? ? type_msg.to_sentence : nil, 'values', comp_msg.any? ? comp_msg.to_sentence : nil].compact.join(' ')
        end

        def method_missing(m, *args, &block)
          if ALLOWED_OPTIONS.include?(m.to_sym)
            raise ArgumentError, "wrong number of arguments (#{args.length} for 1)" if args.length > 1
            send :to_allow, m.to_sym => args.first
          else
            super
          end
        end
      end

      def validate_numericality_of(field)
        ValidateNumericalityOfMatcher.new(field)
      end
    end
  end
end
