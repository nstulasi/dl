   desc "Fetch phases"
   task :fetch_phases  => :environment do
   require 'nokogiri'
  
    @doc = Nokogiri::XML(File.open("project.xml"))
    @doc.xpath("//task").each do |task|
      phase_name = task.xpath("name").text
      phase_start_date = task.xpath("start_date").text
      phase_end_date =  task.xpath("end_date").text
      Phase.create(:name=>phase_name,:start=>phase_start_date,:end=>phase_end_date)
    end
  end

