class DropColumnsFromTask < ActiveRecord::Migration
  def up
    remove_column :tasks,:site
    remove_column :tasks,:owner_id
  end

  def down
  end
end
