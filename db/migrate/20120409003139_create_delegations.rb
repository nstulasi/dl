class CreateDelegations < ActiveRecord::Migration
  def change
    create_table :delegations do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :role
      t.string :responsibility
      t.datetime :created_at

      t.timestamps
    end
  end
end
