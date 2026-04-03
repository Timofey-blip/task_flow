# test/test_state.rb

require_relative 'test_helper'

describe TaskFlow::State do
  describe '#initialize' do
    it 'создаёт состояние с именем' do
      state = TaskFlow::State.new(:created)
      
      assert_equal :created, state.name
    end

    it 'преобразует строку в символ' do
      state = TaskFlow::State.new('created')
      assert_equal :created, state.name
      assert_kind_of Symbol, state.name
    end
  end

  describe '#==' do
    it 'возвращает true для одинаковых состояний' do
      state1 = TaskFlow::State.new(:created)
      state2 = TaskFlow::State.new(:created)
      assert_equal state1, state2
    end

    it 'возвращает false для разных состояний' do
      state1 = TaskFlow::State.new(:created)
      state2 = TaskFlow::State.new(:paid)
      refute_equal state1, state2
    end

    it 'возвращает false для не-State объектов' do
      state = TaskFlow::State.new(:created)
      refute_equal state, 'created'
    end
  end

  describe '#to_s' do
    it 'возвращает строковое представление' do
      state = TaskFlow::State.new(:created)
      assert_equal 'created', state.to_s
    end
  end
end