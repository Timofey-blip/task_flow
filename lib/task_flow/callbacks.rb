# lib/task_flow/callbacks.rb

module TaskFlow
  module Callbacks
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def before_transition(options = {}, &block)
        callbacks[:before] << {
          from: options[:from],
          to: options[:to],
          block: block
        }
      end

      def after_transition(options = {}, &block)
        callbacks[:after] << {
          from: options[:from],
          to: options[:to],
          block: block
        }
      end

      def callbacks
        @callbacks ||= { before: [], after: [] }
      end
    end

    def run_before_callbacks(from, to)
      self.class.callbacks[:before].each do |callback|
        if should_run_callback?(callback, from, to)
          instance_exec(&callback[:block])
        end
      end
    end

    def run_after_callbacks(from, to)
      self.class.callbacks[:after].each do |callback|
        if should_run_callback?(callback, from, to)
          instance_exec(&callback[:block])
        end
      end
    end

    private

    def should_run_callback?(callback, from, to)
      match_from = callback[:from].nil? || callback[:from] == from
      match_to = callback[:to].nil? || callback[:to] == to
      match_from && match_to
    end
  end
end
