   desc "Fetch policies"
   task :fetch_dpolicies  => :environment do
   require 'nokogiri'
  
   @doc = Nokogiri::XML(File.open("project-dpolicies.xml"))
   @doc.xpath("//dpolicy").each do |dp|
      dp_name = dp.xpath("name").text
      dp_sample = dp.xpath("sample").text
      dp_hint=  dp.xpath("hint").text
      DefaultPolicy.create(:name=>dp_name,:sample=>dp_sample,:hint=>dp_hint)
    end
  end