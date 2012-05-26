module StreamsHelper 
  def xmler(xml,type,type_encoding)
    type.each_with_index do |t,index|
      if !params[t].nil?
         xml.type{
           xml.name{xml.text t}
           if !params[type_encoding[index]].nil?
              for encoding in params[type_encoding[index]]
                xml.encoding { xml.text encoding }
              end
           end
         }
       end
    end
  end 
end
