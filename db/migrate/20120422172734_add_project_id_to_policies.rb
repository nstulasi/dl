class AddProjectIdToPolicies < ActiveRecord::Migration
  def change
        add_column :policies, :project_id, :integer
  end
end
