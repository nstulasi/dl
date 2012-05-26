require 'nokogiri'

builder = Nokogiri::XML::Builder.new do |xml|
  xml.books {
    xml.book {
      xml.title { xml.text 'foobar' }
      xml.author { xml.text 'Me' }
    }
  }
end

puts builder.to_xml
file = File.new('dir.xml','w')
file.puts builder.to_xml
file.close