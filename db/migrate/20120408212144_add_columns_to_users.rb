class AddColumnsToUsers < ActiveRecord::Migration
 def change
    add_column :users, :role, :string
    add_column :users, :responsibilities, :string
    add_column :users, :webpage, :string
    add_column :users, :number, :string
    
  end
end
