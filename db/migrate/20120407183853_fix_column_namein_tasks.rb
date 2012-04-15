class FixColumnNameinTasks < ActiveRecord::Migration
  def up
    rename_column :tasks, :due_date, :end_at
    rename_column :tasks, :start_date, :start_at  
  end

  def down
    # rename back if you need or do something else or do nothing
  end

end
