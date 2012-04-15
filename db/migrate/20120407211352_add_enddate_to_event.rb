class AddEnddateToEvent < ActiveRecord::Migration
  def change
    add_column :events, :end_at, :date
  end
end
