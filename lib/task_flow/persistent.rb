require_relative 'persistent/storage'

module TaskFlow
  module Persistent
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def task_flow(workflow_name, options = {})
        @workflow_name = workflow_name
        @storage_class = options[:storage] || TaskFlow::Persistent::Storage
        
      
        if respond_to?(:attribute)
          attribute :workflow_state, :string
          attribute :workflow_data, :text
        end
        
        include InstanceMethods
      end
    end

    module InstanceMethods
     
      def workflow_state
        read_attribute(:workflow_state)&.to_sym
      end

      
      def workflow_state=(state)
        write_attribute(:workflow_state, state.to_s)
      end

      
      def workflow_definition
        @workflow_definition ||= TaskFlow.define(self.class.instance_variable_get(:@workflow_name)) do
          
        end
      end

      
      def fire_workflow_event(event)
        machine = TaskFlow::StateMachine.new(workflow_definition)
        machine.current_state = workflow_definition.get_state(workflow_state)
        
        if machine.fire_event(event)
          self.workflow_state = machine.current_state.name
          save!
          true
        else
          false
        end
      end

      
      def save_workflow_state
        save!
      end

      
      def load_workflow_state
        reload
        workflow_state
      end
    end
  end
end
