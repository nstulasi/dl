class RemoveTimeFromProject < ActiveRecord::Migration
  def up
    remove_column :projects,:time
  end

  def down
  end
end
