class Assignment < ActiveRecord::Base
  belongs_to :delegation
  belongs_to :task
  accepts_nested_attributes_for :task, :delegation
  attr_accessible :delegations, :tasks, :delegation_id, :task_id
end
