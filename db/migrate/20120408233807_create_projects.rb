class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :time
      t.string :money
      t.string :funding_agency

      t.timestamps
    end
  end
end
