class AddDefaultPolicyIdToPolicies < ActiveRecord::Migration
  def change
    add_column :policies, :default_policy_id, :integer
  end
end
