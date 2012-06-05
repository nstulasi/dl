class CreateScenarios < ActiveRecord::Migration
  def change
    create_table :scenarios do |t|
      t.string :xmlcontent
      t.integer :project_id

      t.timestamps
    end
  end
end
