class AddSiteToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :site, :string
  end
end
