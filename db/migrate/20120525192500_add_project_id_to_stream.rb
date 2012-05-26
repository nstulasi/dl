class AddProjectIdToStream < ActiveRecord::Migration
  def change
    add_column :streams, :project_id, :integer
  end
end
