class ChangeColumnNameInEvents < ActiveRecord::Migration
  def up
    rename_column :events, :date, :start_at
  end

  def down
  end
end
