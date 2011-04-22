module Mongoid
  module Matchers
    module Validations
      class ValidateNumericalityOfMatcher < HaveValidationMatcher
        @@allowed_options = [:equal_to, :greater_than, :greater_than_or_equal_to, :less_than, :less_than_or_equal_to, 
          :even, :odd, :only_integer, :allow_nil, :nil]
        
        def initialize(field)
          super(field, :numericality)
          @options = {}
        end
        
        def to_allow(options)
          options[:equal_to] = options if options.is_a?(Numeric)
          options[:allow_nil] = options.delete(:nil) if options.has_key?(:nil)
          raise ArgumentError, "validate_numericality_of#to_allow requires a Hash parameter containing any of the following keys: " <<
            @@allowed_options.map(&:inspect).join(", ") if !options.is_a?(Hash) or options.empty? or (options.keys - @@allowed_options).any?
          @options.merge!(options)
          self
        end

        def matches?(actual)
          return false unless result = super(actual)
          
          @@allowed_options.each do |comparator|
            if @options.has_key?(comparator) and !([:even, :odd, :only_integer].include?(comparator) and !@validator.options.include?(comparator))
              result &= (@validator.options[comparator] == @options[comparator])
            end
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
              type_msg << "integer" if value
            when :odd, :even
              type_msg << "#{key.to_s}-numbered" if value
            else
              comp_msg << "#{key.to_s.gsub("_", " ")} #{value.inspect}"
            end
          end
          allow_nil = (options[:allow_nil] ? "nil" : "non-nil") if options.has_key?(:allow_nil)          
          ["", "allowing", allow_nil, type_msg.any? ? type_msg.to_sentence : nil, "values", comp_msg.any? ? comp_msg.to_sentence : nil].compact.join(" ")
        end        
        
        def method_missing(m, *args, &block)
          if @@allowed_options.include?(m.to_sym)
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