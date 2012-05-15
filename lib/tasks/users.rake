   desc "Fetch users"
   task :fetch_users  => :environment do
   require 'nokogiri'
  
    @doc = Nokogiri::XML(File.open("project-users.xml"))
    @doc.xpath("//user").each do |user|
      user_name = user.xpath("name").text
      user_email = user.xpath("email").text
      user_webpage =  user.xpath("webpage").text
      user_number =  user.xpath("number").text
      User.create(:name=>user_name,:email=>user_email,:webpage=>user_webpage,:number=>user_number,:admin=>"f")
    end
  end

