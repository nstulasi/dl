class RemoveColumnsFromUser < ActiveRecord::Migration
  def up
      remove_column :users,:role
      remove_column :users,:responsibilities
      remove_column :users,:admin
  end

  def down
  end
end
