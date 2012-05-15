class CreateDefaultphases < ActiveRecord::Migration
  def change
    create_table :defaultphases do |t|
      t.string :name

      t.timestamps
    end
  end
end
