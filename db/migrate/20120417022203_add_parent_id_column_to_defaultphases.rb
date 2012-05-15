class AddParentIdColumnToDefaultphases < ActiveRecord::Migration
  def change
    add_column :defaultphases, :parent_id, :integer 
  end
end
