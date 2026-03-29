# db/migrate/create_workflow_states.rb

class CreateWorkflowStates < ActiveRecord::Migration[7.0]
  def change
    create_table :workflow_states do |t|
      t.integer :record_id, null: false
      t.string :workflow_name, null: false
      t.string :state
      t.text :data
      t.json :transitions, default: []
      
      t.timestamps
    end
    
    add_index :workflow_states, [:record_id, :workflow_name], unique: true
  end
end
