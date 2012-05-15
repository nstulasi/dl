   desc "Fetch phases"
   task :fetch_dphases  => :environment do
   require 'nokogiri'
  
   @doc = Nokogiri::XML(File.open("project-dphases.xml"))
   @doc.xpath("//dphase").each do |dphase|
      dphase_name = dphase.xpath("name").text
      dphase_content = dphase.xpath("content").text
      dphase_parent_id =  dphase.xpath("parent_id").text
      Defaultphase.create(:name=>dphase_name,:content=>dphase_content,:parent_id=>dphase_parent_id)
    end
  end

