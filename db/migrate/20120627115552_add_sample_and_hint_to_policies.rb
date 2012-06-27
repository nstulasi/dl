class AddSampleAndHintToPolicies < ActiveRecord::Migration
  def change
    add_column :policies, :sample, :string
    add_column :policies, :hint, :string
  end
end
