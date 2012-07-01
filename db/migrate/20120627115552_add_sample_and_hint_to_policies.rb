class AddSampleAndHintToPolicies < ActiveRecord::Migration
  def change
    add_column :policies, :sample, :string
    add_column :policies, :hint, :string
    add_column :policies, :default_policy_id, :integer
  end
end
