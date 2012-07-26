class AddStartAndEndDateToProject < ActiveRecord::Migration
  def change
    add_column :projects, :start_at, :date
    add_column :projects, :end_at, :date
    remove_column :projects, :time
  end
end
