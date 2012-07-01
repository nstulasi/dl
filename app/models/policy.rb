class Policy < ActiveRecord::Base
  belongs_to :project, :foreign_key=>:project_id
  belongs_to :default_policy, :foreign_key=>:default_policy_id
  attr_accessible :name
end
