class AddStartAndEndToPhaes < ActiveRecord::Migration
  def change
    add_column :phases, :start, :datetime
    add_column :phases, :end, :datetime
  end
end
