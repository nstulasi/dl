class CreateSocieties < ActiveRecord::Migration
  def change
    create_table :societies do |t|
      t.string :xmlcontent
      t.integer :project_id

      t.timestamps
    end
  end
end
