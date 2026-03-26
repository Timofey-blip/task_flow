# lib/task_flow/definition.rb

require_relative 'state'
require_relative 'transition'

module TaskFlow
  class Definition
    attr_reader :states, :transitions, :name

    def initialize(name)
      @name = name.to_sym
      @states = []
      @transitions = []
      @states_by_name = {}
      @transitions_by_event = {}
    end

    # Добавить состояние
    def state(name)
      state_obj = State.new(name)
      @states << state_obj
      @states_by_name[state_obj.name] = state_obj
      state_obj
    end

    # Добавить переход
    def transition(transition_def)
      from_state = transition_def.keys.first
      to_state = transition_def.values.first
      event = transition_def[:event] || transition_def[:on] || :transition

      # Создаём состояния если их нет
      from_obj = @states_by_name[from_state.to_sym] || state(from_state)
      to_obj = @states_by_name[to_state.to_sym] || state(to_state)

      transition_obj = Transition.new(
        from: from_obj,
        to: to_obj,
        event: event
      )

      @transitions << transition_obj
      @transitions_by_event[event] = transition_obj
      transition_obj
    end

    # Получить состояние по имени
    def get_state(name)
      @states_by_name[name.to_sym]
    end

    # Получить переход по событию
    def get_transition_by_event(event)
      @transitions_by_event[event.to_sym]
    end

    # Получить все события для состояния
    def events_for(state_name)
      state_name = state_name.is_a?(State) ? state_name.name : state_name.to_sym
      @transitions
        .select { |t| t.from.name == state_name }
        .map(&:event)
    end

    def to_s
      "TaskFlow::Definition(#{@name}): #{@states.size} states, #{@transitions.size} transitions"
    end
  end
end