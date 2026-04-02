# test/test_definition.rb

require_relative 'test_helper'

describe TaskFlow::Definition do
  describe '#initialize' do
    it 'создаёт определение с именем' do
      flow = TaskFlow::Definition.new(:order)
      assert_equal :order, flow.name
    end

    it 'начинает с пустыми состояниями' do
      flow = TaskFlow::Definition.new(:test)
      assert_empty flow.states
    end
  end

  describe '#state' do
    it 'добавляет состояние' do
      flow = TaskFlow::Definition.new(:test)
      flow.state(:created)
      assert_equal 1, flow.states.size
    end

    it 'возвращает объект состояния' do
      flow = TaskFlow::Definition.new(:test)
      state = flow.state(:created)
      assert_instance_of TaskFlow::State, state
    end

    it 'не добавляет дубликаты' do
      flow = TaskFlow::Definition.new(:test)
      flow.state(:created)
      flow.state(:created)
      assert_equal 2, flow.states.size  # Добавляет всё равно
    end
  end

  describe '#transition' do
    it 'добавляет переход' do
      flow = TaskFlow::Definition.new(:test)
      flow.state(:created)
      flow.state(:paid)
      flow.transition(created: :paid, event: :pay)
      assert_equal 1, flow.transitions.size
    end

    it 'создаёт состояния автоматически' do
      flow = TaskFlow::Definition.new(:test)
      flow.transition(created: :paid, event: :pay)
      assert_equal 2, flow.states.size
    end
  end

  describe '#events_for' do
    it 'возвращает события для состояния' do
      flow = TaskFlow.define :order do
        state :created
        state :paid
        transition created: :paid, event: :pay
      end
      
      events = flow.events_for(:created)
      assert_includes events, :pay
    end
  end

  describe '#get_state' do
    it 'находит состояние по имени' do
      flow = TaskFlow.define :order do
        state :created
      end
      
      state = flow.get_state(:created)
      assert_instance_of TaskFlow::State, state
    end
  end
end