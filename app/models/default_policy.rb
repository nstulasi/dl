class DefaultPolicy < ActiveRecord::Base
  has_many :policies
  accepts_nested_attributes_for :policies
end
