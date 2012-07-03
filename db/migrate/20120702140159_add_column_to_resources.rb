class AddColumnToResources < ActiveRecord::Migration
  def change
    add_column :resources, :resourcer, :string
  end
end
