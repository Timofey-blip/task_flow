# examples/persistence_example.rb

require_relative '../lib/task_flow'
require 'active_record'


ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'development.db'
)


class Order < ActiveRecord::Base
  include TaskFlow::Persistent
  
  task_flow :order
end


order = Order.create!(workflow_state: :created)


order.fire_workflow_event(:pay)     
order.fire_workflow_event(:ship)     
order.fire_workflow_event(:deliver)  


order.save_workflow_state


order.reload
puts order.workflow_state
