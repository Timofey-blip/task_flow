module TaskFlow
  class Transition
    attr_reader :from, :to, :event

    def initialize(from:, to:, event:)
      @from = from.is_a?(State) ? from : State.new(from)
      @to = to.is_a?(State) ? to : State.new(to)
      @event = event.to_sym
    end

    def to_s
      "#{@from} --[:#{@event}]--> #{@to}"
    end

    def inspect
      "#<TaskFlow::Transition #{to_s}>"
    end
  end
end