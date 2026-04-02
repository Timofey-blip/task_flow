# test/test_transition.rb

require_relative 'test_helper'

describe TaskFlow::Transition do
  describe '#initialize' do
    it 'создаёт переход с from, to, event' do
      transition = TaskFlow::Transition.new(
        from: :created,
        to: :paid,
        event: :pay
      )
      
      assert_equal :created, transition.from.name
      assert_equal :paid, transition.to.name
      assert_equal :pay, transition.event
    end

    it 'принимает State объекты' do
      from_state = TaskFlow::State.new(:created)
      to_state = TaskFlow::State.new(:paid)
      
      transition = TaskFlow::Transition.new(
        from: from_state,
        to: to_state,
        event: :pay
      )
      
      assert_equal from_state, transition.from
      assert_equal to_state, transition.to
    end
  end

  describe '#to_s' do
    it 'возвращает строковое представление' do
      transition = TaskFlow::Transition.new(
        from: :created,
        to: :paid,
        event: :pay
      )
      
      assert_equal 'created --[:pay]--> paid', transition.to_s
    end
  end
end