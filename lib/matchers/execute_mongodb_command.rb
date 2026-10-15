# frozen_string_literal: true

module Mongoid
  module Matchers
    def execute_mongodb_command(*expected_commands)
      raise ArgumentError, 'execute_mongodb_command accepts at most one command' if expected_commands.length > 1

      if expected_commands.empty?
        ExecuteMongodbCommand.new
      else
        ExecuteMongodbCommand.new(expected_commands.first)
      end
    end

    class ExecuteMongodbCommand
      DRIVER_METADATA_KEYS = %w[$db lsid $clusterTime].freeze
      UNSPECIFIED = Object.new.freeze

      def initialize(expected_command = UNSPECIFIED)
        @expected_command = expected_command.equal?(UNSPECIFIED) ? nil : normalize_command(expected_command)
      end

      def supports_block_expectations?
        true
      end

      def matches?(block)
        raise ArgumentError, 'execute_mongodb_command expects a block' unless block
        raise NotImplementedError, 'execute_mongodb_command requires MongoDB driver command monitoring' unless
          defined?(Mongo::Monitoring::Global) && defined?(Mongo::Monitoring::COMMAND)
        raise NotImplementedError, 'execute_mongodb_command requires the Mongoid client registry' unless
          defined?(Mongoid::Clients) && Mongoid::Clients.respond_to?(:clients)

        @command_executed = false
        topic = Mongo::Monitoring::COMMAND
        global_monitor = Mongo::Monitoring::Global
        subscriber = CommandSubscriber.new(Thread.current, @expected_command, method(:normalize_command)) do
          @command_executed = true
        end
        clients = mongoid_clients
        subscribed = false

        begin
          clients.each { |client| client.subscribe(topic, subscriber) }
          global_monitor.subscribe(topic, subscriber)
          subscribed = true
          block.call
        ensure
          current_clients = mongoid_clients
          global_monitor.unsubscribe(topic, subscriber) if subscribed
          (clients + current_clients).uniq.each { |client| client.unsubscribe(topic, subscriber) }
        end

        @command_executed
      end

      def failure_message
        message = +'Expected block to execute a MongoDB command'
        message << " matching #{@expected_command.inspect}" if @expected_command
        message
      end

      def failure_message_when_negated
        message = +'Expected block not to execute a MongoDB command'
        message << " matching #{@expected_command.inspect}" if @expected_command
        message
      end

      private

      def normalize_command(command)
        raise ArgumentError, 'expected MongoDB command must be a non-empty Hash' unless command.is_a?(Hash) && !command.empty?

        normalize_document(command, top_level: true)
      end

      def normalize_document(document, top_level: false)
        document.each_with_object({}) do |(key, value), normalized|
          normalized_key = normalize_key(key)
          next if top_level && DRIVER_METADATA_KEYS.include?(normalized_key)
          raise ArgumentError, "duplicate MongoDB command key after normalization: #{normalized_key.inspect}" if normalized.key?(normalized_key)

          normalized[normalized_key] = normalize_value(value)
        end
      end

      def normalize_key(key)
        return key if key.is_a?(String)
        return key.to_s if key.is_a?(Symbol)

        raise ArgumentError, "MongoDB command keys must be Strings or Symbols, got #{key.class}"
      end

      def normalize_value(value)
        case value
        when Hash then normalize_document(value)
        when Array then value.map { |item| normalize_value(item) }
        else value
        end
      end

      def mongoid_clients
        Mongoid::Clients.clients.values
      end

      class CommandSubscriber
        def initialize(thread, expected_command, normalizer, &on_command)
          @thread = thread
          @expected_command = expected_command
          @normalizer = normalizer
          @on_command = on_command
        end

        def started(event)
          return unless Thread.current.equal?(@thread)

          command = @normalizer.call(event.command)
          @on_command.call if @expected_command.nil? || command == @expected_command
        end

        def succeeded(_event); end

        def failed(_event); end
      end
    end
  end
end
