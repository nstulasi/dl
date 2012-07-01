class CreateDefaultPolicies < ActiveRecord::Migration
  def change
    create_table :default_policies do |t|
      t.string :name
      t.string :sample
      t.string :hint

      t.timestamps
    end
  end
end
