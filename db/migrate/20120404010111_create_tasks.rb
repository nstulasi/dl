class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :owner_id
      t.string :name
      t.string :status
      t.string :priority
      t.date :due_date

      t.timestamps
    end
  end
end
