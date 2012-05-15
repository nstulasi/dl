class AddParentIdColumnToPhases < ActiveRecord::Migration
  def change
    add_column :phases, :parent_id, :integer
  end
end
