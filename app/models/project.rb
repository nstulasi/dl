class Project < ActiveRecord::Base
  has_many :delegations
  has_many :users, :through=>:delegations
  has_many :tasks
  has_many :policies
  has_one :metum
  
  validates :name, :presence => true,
                  :length => {:maximum => 50}

  accepts_nested_attributes_for :delegations, :allow_destroy=>true #All i had to do was add allow destroy to allow a delegation to be destroyed from project edit button!
  accepts_nested_attributes_for :tasks
  accepts_nested_attributes_for :users, :allow_destroy=>true
  accepts_nested_attributes_for :policies
  
  
  attr_accessible :users_attributes, :delegations_attributes, :phases_attributes, :users, :name, :project_attributes,:money,:start_at,:end_at,:funding_agency,:description
  
  has_many :events
  accepts_nested_attributes_for :events
  attr_accessor :project_user
  
  has_many :phases
  accepts_nested_attributes_for :phases, :allow_destroy=>true
  
  has_many :resources, :as => :resourceable 
    
  def should_validate_user
  project_user
  end
  
  def self.search(search)
  if search
    where('name LIKE ?', "%#{search}%")
  else
    scoped
  end
end
  
end
