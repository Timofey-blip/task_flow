# test_flow.rb

require_relative 'lib/task_flow'

# Пример 1: Простой workflow заказа
puts "=== Order Flow ==="
order_flow = TaskFlow.define :order do
  state :created
  state :paid
  state :shipped
  state :delivered

  transition created: :paid, event: :pay
  transition paid: :shipped, event: :ship
  transition shipped: :delivered, event: :deliver
end

puts order_flow
puts "States: #{order_flow.states.map(&:name)}"
puts "Transitions:"
order_flow.transitions.each { |t| puts "  #{t}" }
puts "Events for :created: #{order_flow.events_for(:created)}"
puts

# Пример 2: Workflow документа
puts "=== Document Flow ==="
doc_flow = TaskFlow.define :document do
  state :draft
  state :review
  state :approved
  state :rejected

  transition draft: :review, event: :submit
  transition review: :approved, event: :approve
  transition review: :rejected, event: :reject
  transition rejected: :draft, event: :revise
end

puts doc_flow
puts "States: #{doc_flow.states.map(&:name)}"
puts "Transitions:"
doc_flow.transitions.each { |t| puts "  #{t}" }
puts "Events for :review: #{doc_flow.events_for(:review)}"