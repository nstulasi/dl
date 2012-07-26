class Task < ActiveRecord::Base
  
  has_many :assignments
  belongs_to :project, :foreign_key=>:project_id
  has_many :delegations, :through=>:assignments
  accepts_nested_attributes_for :assignments, :allow_destroy => true
  has_event_calendar
  validates :name, :presence => true
  validates :content, :presence => true
  validates :start_at, :presence => true
  validates :end_at, :presence => true
  
  has_many :resources, :as => :resourceable
  attr_accessible :name, :start_at, :end_at,:status,:priority,:assignments_attributes,:project_id,:content
  
                 
   
  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def self.get_csv(options = {})
    columns=["name","start_at","end_at"]
  CSV.generate(options) do |csv|
    csv << columns
    all.each do |task|
      csv << task.attributes.values_at(*columns)
    end
  end
end

end
