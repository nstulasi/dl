class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :delegation_id
      t.integer :task_id
      t.datetime :created_at

      t.timestamps
    end
  end
end
