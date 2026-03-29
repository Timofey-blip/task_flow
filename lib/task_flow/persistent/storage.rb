module TaskFlow
  module Persistent
    class Storage
      def self.save(record_id, workflow_name, state, data = {})
        find_or_create(record_id, workflow_name).update(
          state: state.to_s,
          data: data.to_json,
          updated_at: Time.now
        )
      end

      def self.load(record_id, workflow_name)
        record = find(record_id, workflow_name)
        return nil unless record

        {
          state: record.state&.to_sym,
          data: JSON.parse(record.data || '{}'),
          updated_at: record.updated_at
        }
      end

      def self.delete(record_id, workflow_name)
        record = find(record_id, workflow_name)
        record.destroy if record
      end

      def self.history(record_id, workflow_name)
        record = find(record_id, workflow_name)
        return [] unless record

        record.transitions || []
      end

      def self.add_transition(record_id, workflow_name, from, to, event)
        record = find_or_create(record_id, workflow_name)
        transitions = record.transitions || []
        transitions << {
          from: from,
          to: to,
          event: event,
          at: Time.now
        }
        record.update(transitions: transitions)
      end

      private

      def self.find(record_id, workflow_name)
        nil
      end

      def self.find_or_create(record_id, workflow_name)
        find(record_id, workflow_name) || create(
          record_id: record_id,
          workflow_name: workflow_name
        )
      end

      def self.create(attributes)
        OpenStruct.new(attributes.merge(
          state: nil,
          data: '{}',
          transitions: [],
          created_at: Time.now,
          updated_at: Time.now
        ))
      end
    end
  end
end
