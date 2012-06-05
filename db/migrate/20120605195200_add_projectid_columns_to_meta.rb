class AddProjectidColumnsToMeta < ActiveRecord::Migration
  def change
    add_column :meta, :project_id, :string
  end
end
