class Delegation < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  accepts_nested_attributes_for :user, :allow_destroy => true
  
  attr_accessible :user_id, :project_id,:role, :responsibility, :user_attributes
  
  has_many :assignments
  has_many :tasks, :through => :assignments
  accepts_nested_attributes_for :assignments, :tasks
  attr_accessible :assignments, :assignments_attributes
end
