# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mongoid::Matchers::ExecuteMongodbCommand do
  before do
    Article.collection
  end

  if defined?(Mongo::Monitoring::Global) && defined?(Mongo::Monitoring::COMMAND)
    let(:expected_command) do
      {
        find: 'articles',
        filter: { content: 'cached' },
        limit: 10,
        sort: { created_at: -1 }
      }
    end

    let(:query) do
      Article.where(content: 'cached').desc(:created_at).limit(10).to_a
    end

    it 'detects any MongoDB command' do
      expect { Article.count }.to execute_mongodb_command
    end

    it 'matches the full application command with normalized keys' do
      expect { query }.to execute_mongodb_command(expected_command)
    end

    it 'ignores driver metadata when matching the command' do
      expected_with_metadata = expected_command.merge(
        '$db' => 'a-different-database',
        lsid: { id: 'not the generated session id' },
        '$clusterTime' => { clusterTime: 'not the generated cluster time' }
      )

      expect { query }.to execute_mongodb_command(expected_with_metadata)
    end

    it 'does not match a different command value' do
      different_command = expected_command.merge(filter: { content: 'different' })

      expect { query }.not_to execute_mongodb_command(different_command)
    end

    it 'does not match a partial command document' do
      expect { query }.not_to execute_mongodb_command(find: 'articles')
    end

    it 'does not detect lazy criteria' do
      expect { Article.where(content: 'cached') }.not_to execute_mongodb_command
    end

    it 'ignores commands issued on another thread' do
      expect { Thread.new { Article.count }.value }.not_to execute_mongodb_command
    end

    it 'provides a failure message when no command is issued' do
      expect do
        expect { Article.where(content: 'cached') }.to execute_mongodb_command
      end.to raise_error(RSpec::Expectations::ExpectationNotMetError, /Expected block to execute a MongoDB command/)
    end

    it 'provides a failure message when a command is issued' do
      expect do
        expect { Article.count }.not_to execute_mongodb_command
      end.to raise_error(RSpec::Expectations::ExpectationNotMetError, /Expected block not to execute a MongoDB command/)
    end

    it 'rejects an invalid expected command' do
      expect { execute_mongodb_command(nil) }.to raise_error(ArgumentError, /must be a non-empty Hash/)
      expect { execute_mongodb_command('find') }.to raise_error(ArgumentError, /must be a non-empty Hash/)
    end

    it 'rejects duplicate keys after String and Symbol normalization' do
      expect do
        execute_mongodb_command('find' => 'articles', find: 'other')
      end.to raise_error(ArgumentError, /duplicate MongoDB command key/)
    end

    it 'unsubscribes listeners when the block raises' do
      topic = Mongo::Monitoring::COMMAND
      global_subscribers = Mongo::Monitoring::Global.subscribers[topic].dup
      client_subscribers = client_command_subscribers(topic)

      expect do
        expect { raise 'block failed' }.not_to execute_mongodb_command
      end.to raise_error('block failed')

      expect(Mongo::Monitoring::Global.subscribers[topic]).to eq(global_subscribers)
      expect(client_command_subscribers(topic)).to eq(client_subscribers)
    end

    it 'unsubscribes listeners after matching' do
      topic = Mongo::Monitoring::COMMAND
      global_subscribers = Mongo::Monitoring::Global.subscribers[topic].dup
      client_subscribers = client_command_subscribers(topic)

      expect { Article.count }.to execute_mongodb_command

      expect(Mongo::Monitoring::Global.subscribers[topic]).to eq(global_subscribers)
      expect(client_command_subscribers(topic)).to eq(client_subscribers)
    end
  else
    it 'reports that command monitoring is unsupported by the MongoDB driver' do
      expect do
        expect { Article.count }.to execute_mongodb_command
      end.to raise_error(NotImplementedError, /requires MongoDB driver command monitoring/)
    end
  end

  def client_command_subscribers(topic)
    Mongoid::Clients.clients.values.map do |client|
      client.__send__(:monitoring).subscribers[topic].dup
    end
  end
end
