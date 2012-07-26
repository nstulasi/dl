class Phase < ActiveRecord::Base
  acts_as_nested_set
  belongs_to :project
  attr_accessible :name,:start,:end,:content
  validates :name, :presence => true
  validates :start, :presence => true
  validates :end, :presence => true
  
  def self.get_csv(options = {})
    columns=["name","start","end"]
  CSV.generate(options) do |csv|
    csv << columns
    all.each do |phase|
      csv << phase.attributes.values_at(*columns)
    end
  end
end

end
