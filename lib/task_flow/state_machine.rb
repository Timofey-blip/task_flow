module TaskFlow
  class StateMachine
    attr_reader :current_state, :definition, :history

    def initialize(definition, start_state = nil)
      @definition = definition
      @current_state = start_state || definition.states.first
      @history = []
    end

    def fire_event(event)
      transition = definition.get_transition_by_event(event)
      
      if transition && transition.from.name == current_state.name
        old_state = current_state
        
        run_before_callbacks(old_state.name, transition.to.name) if respond_to?(:run_before_callbacks)
        @current_state = transition.to
      
        @history « {
          from: old_state.name,
          to: transition.to.name,
          event: event,
          at: Time.now
        }
        
        run_after_callbacks(old_state.name, transition.to.name) if respond_to?(:run_after_callbacks)
        
        true
      else
        false
      end
    end

    def can_transition?(event)
      transition = definition.get_transition_by_event(event)
      transition && transition.from.name == current_state.name
    end

    def available_events
      definition.events_for(current_state.name)
    end

    def state
      current_state.name
    end

    def transitions_history
      history
    end

    def state=(state_name)
      state_obj = definition.get_state(state_name)
      if state_obj
        @current_state = state_obj
        true
      else
        false
      end
    end

    def reset
      @current_state = definition.states.first
      @history = []
    end

    private

    def run_before_callbacks(from, to)
    end

    def run_after_callbacks(from, to)
    end  
  end
end
