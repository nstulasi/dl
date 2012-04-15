class Project < ActiveRecord::Base
  has_many :delegations
  has_many :users, :through=>:delegations
  
  accepts_nested_attributes_for :delegations, :allow_destroy=>true #All i had to do was add allow destroy to allow a delegation to be destroyed from project edit button!
  accepts_nested_attributes_for :users, :allow_destroy=>true
  
  attr_accessible :users_attributes, :delegations_attributes, :users, :name, :project_attributes
  
  has_many :events
  accepts_nested_attributes_for :events
  attr_accessor :project_user
    
  def should_validate_user
  project_user
  end
  
  def destroy_na
    puts "**************************************!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!****************************************!!!!!!!"
  end
  
end
