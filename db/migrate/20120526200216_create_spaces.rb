class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|
      t.string :xmlcontent
      t.integer :project_id

      t.timestamps
    end
  end
end
