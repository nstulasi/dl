class Event < ActiveRecord::Base
  has_event_calendar
  belongs_to :project 
  
    def self.get_csv(options = {})
    columns=["name","start_at","end_at"]
  CSV.generate(options) do |csv|
    csv << columns
    all.each do |event|
      csv << event.attributes.values_at(*columns)
    end
  end
end
end
