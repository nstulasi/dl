   desc "Fetch projects"
   task :fetch_projects  => :environment do
   require 'nokogiri'
  
    @doc = Nokogiri::XML(File.open("projects.xml"))
    @doc.xpath("//project").each do |project|
      project_name = project.xpath("name").text
      Project.create(:name=>project_name)
    end
  end

