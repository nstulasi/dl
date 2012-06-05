module MetaHelper
  def xmler(xml,type,type_encoding)
    type.each_with_index do |t,index|
      if !params[t].nil?
         xml.type{
           node = xml.name{
             xml.text t
           }
           node['checked']='true'
           if !params[type_encoding[index]].nil?
              for encoding in params[type_encoding[index]]
                xml.encoding { xml.text encoding }
              end
           end
         }
       else
         xml.type{
           xml.name(:checked=>"false"){
             xml.text t}
           }
       end
    end
  end 
end
