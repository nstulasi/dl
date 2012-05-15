class AddProjectToPhases < ActiveRecord::Migration
  def change
    add_column :phases, :project_id, :integer
  end
end
