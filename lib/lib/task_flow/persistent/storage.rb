# lib/task_flow/persistent/storage.rb
module TaskFlow
  module Persistent
    class Storage
      attr_reader :adapter, :owner_class

      def initialize(adapter:, owner_class:)
        @owner_class = owner_class
        @adapter = initialize_adapter(adapter)
      end

      def save_state(record, state)
        adapter.save_state(record, state)
      end

      def load_state(record)
        adapter.load_state(record)
      end
      def clear_state(record)
        adapter.clear_state(record) if adapter.respond_to?(:clear_state)
      end

      private

      def initialize_adapter(adapter)
        case adapter
        when :active_record
          unless defined?(ActiveRecord::Base)
            raise "ActiveRecord is not available. Please add 'activerecord' to your Gemfile"
          end
          ActiveRecordAdapter.new
        when :in_memory
          InMemoryAdapter.new
        else
          if adapter.respond_to?(:save_state) && adapter.respond_to?(:load_state)
            adapter
          else
            raise "Unknown adapter: #{adapter}. Use :active_record, :in_memory or custom adapter"
          end
        end
      end
    end
  end
end
