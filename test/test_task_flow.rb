# test/test_task_flow.rb

require_relative 'test_helper'

describe TaskFlow do
  describe 'VERSION' do
    it 'имеет номер версии' do
      assert TaskFlow::VERSION
      assert_kind_of String, TaskFlow::VERSION
    end
  end

  describe '.define' do
    it 'создаёт новый workflow' do
      flow = TaskFlow.define :order do
        state :created
        state :paid
      end
      
      assert_instance_of TaskFlow::Definition, flow
      assert_equal :order, flow.name
    end

    it 'принимает блок' do
      flow = TaskFlow.define :order do
        state :created
        state :paid
      end
      
      assert_equal 2, flow.states.size
    end

    it 'работает без блока' do
      flow = TaskFlow.define :empty
      assert_empty flow.states
    end
  end

  describe '.build' do
    it 'алиас для define' do
      flow = TaskFlow.build :test do
        state :created
      end
      
      assert_instance_of TaskFlow::Definition, flow
    end
  end
end