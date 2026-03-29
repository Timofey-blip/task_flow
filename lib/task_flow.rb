# lib/task_flow.rb

require_relative 'task_flow/state'
require_relative 'task_flow/transition'
require_relative 'task_flow/definition'
require_relative 'task_flow/callbacks'
require_relative 'task_flow/persistent'

module TaskFlow
  VERSION = '0.3.0'

  # DSL для создания workflow
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

# Удобный алиас
TaskFlowDSL = TaskFlow
