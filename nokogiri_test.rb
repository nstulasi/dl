require 'rubygems'
require 'nokogiri'


@doc = Nokogiri::XML(File.open("project.xml"))
@doc.xpath("//task").each do |task|
  puts task.xpath("name").text
  puts task.xpath("start_date").text
  puts task.xpath("end_date").text
end

