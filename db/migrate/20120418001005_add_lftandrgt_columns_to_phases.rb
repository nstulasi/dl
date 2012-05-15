class AddLftandrgtColumnsToPhases < ActiveRecord::Migration
  def change
    add_column :phases, :lft, :integer
    add_column :phases, :rgt, :integer
  end
end
