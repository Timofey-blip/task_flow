# lib/task_flow/state.rb

module TaskFlow
  class State
    attr_reader :name

    def initialize(name)
      @name = name.to_sym
    end

    def ==(other)
      other.is_a?(State) && @name == other.name
    end

    def to_s
      @name.to_s
    end

    def inspect
      "#<TaskFlow::State #{@name}>"
    end
  end
end