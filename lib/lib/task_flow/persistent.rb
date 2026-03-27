module TaskFlow
  module Persistent
    extend ActiveSupport::Concern

    included do
      class_attribute :_task_flow_name
      class_attribute :_task_flow_storage
    end

    class_methods do
      def task_flow(flow_name, adapter: :active_record)
        self._task_flow_name = flow_name
        self._task_flow_storage = TaskFlow::Persistent::Storage.new(
          adapter: adapter,
          owner: self
        )
        
        # Добавляем методы для работы с workflow
        include InstanceMethods
      end
    end

    module InstanceMethods
      def workflow
        @workflow ||= begin
          flow_definition = TaskFlow.registry[self.class._task_flow_name]
          state = self.class._task_flow_storage.load_state(self)
          
          TaskFlow::StateMachine.new(
            definition: flow_definition,
            current_state: state,
            persistor: self
          )
        end
      end

      def save_workflow_state(state)
        self.class._task_flow_storage.save_state(self, state)
      end

      def reload_workflow
        @workflow = nil
        workflow
      end
    end
  end
end
