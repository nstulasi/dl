class Task < ActiveRecord::Base
  has_many :assignments
  has_many :delegations, :through=>:assignments
  accepts_nested_attributes_for :assignments, :allow_destroy => true
  has_event_calendar 
  def self.search(search)
  if search
    where('name LIKE ?', "%#{search}%")
  else
    scoped
  end
end
end
