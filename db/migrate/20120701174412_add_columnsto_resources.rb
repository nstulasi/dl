class AddColumnstoResources < ActiveRecord::Migration
  def up
    add_column :resources, :content, :text 
    add_column :resources, :resourceable_id, :integer
    add_column :resources, :resourceable_type,:string
  end

  def down
  end
end
