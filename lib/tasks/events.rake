   desc "Fetch events"
   task :fetch_events  => :environment do
   require 'nokogiri'
  
    @doc = Nokogiri::XML(File.open("project-events.xml"))
    @doc.xpath("//event").each do |event|
      event_name = event.xpath("name").text
      event_start_at = event.xpath("start_at").text
      event_end_at =  event.xpath("end_at").text
      event_project_id =  event.xpath("project_id").text
      Event.create(:name=>event_name,:start_at=>event_start_at,:end_at=>event_end_at,:project_id=>event_project_id)
    end
  end

