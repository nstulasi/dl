class Task < ActiveRecord::Base
  has_many :assignments
  belongs_to :project, :foreign_key=>:project_id
  has_many :delegations, :through=>:assignments
  accepts_nested_attributes_for :assignments, :allow_destroy => true
  has_event_calendar
  validates :name, :presence => true
   has_many :resources, :as => :resourceable
                 
   
  def self.search(search)
  if search
    where('name LIKE ?', "%#{search}%")
  else
    scoped
  end
end
end
