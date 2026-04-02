require_relative 'task_flow/version'
require_relative 'task_flow/state'
require_relative 'task_flow/transition'
require_relative 'task_flow/definition'
require_relative 'task_flow/callbacks'

module TaskFlow
  class << self
    def define(name, &block)
      definition = Definition.new(name)
      definition.instance_eval(&block) if block_given?
      definition
    end

    def build(name, &block)
      define(name, &block)
    end
  end
end


TaskFlowDSL = TaskFlow




