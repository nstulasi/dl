class CreateStructures < ActiveRecord::Migration
  def change
    create_table :structures do |t|
      t.string :xmlcontent
      t.integer :project_id

      t.timestamps
    end
  end
end
