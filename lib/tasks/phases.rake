   desc "Fetch phases"
   task :fetch_phases  => :environment do
   require 'nokogiri'
  
    @doc = Nokogiri::XML(File.open("project-phases.xml"))
    @doc.xpath("//phase").each do |phase|
      phase_name = phase.xpath("name").text
      phase_content = phase.xpath("content").text
      phase_project_id= phase.xpath("project_id").text
      phase_parent_id = phase.xpath("parent_id").text
      phase_start_date = phase.xpath("start_date").text
      phase_end_date =  phase.xpath("end_date").text
      phase_site = phase.xpath("site").text
      Phase.create(:name=>phase_name,:project_id=>phase_project_id,:parent_id=>phase_parent_id,:start=>phase_start_date,:end=>phase_end_date,:site=>phase_site)
    end
  end

