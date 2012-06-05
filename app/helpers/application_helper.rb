module ApplicationHelper
  #return title on a per-page basis
  def title
    base_title = "Digital Library  Management Tool"
    if @title.nil?
      base_title
    else
      "#{base_title}|#{@title}"
    end
  end
  def logo
    link_to image_tag("green_2.jpg", :alt=>"Digital library Management Tool", :class =>'round'),projects_path
  end
  
 def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page=>nil), {:class => css_class}
  end
  
  def add_phase_link(name)
      link_to name, "#", "partial" => h(render(:partial => 'phase', :object => Phase.new)), :class => 'phases'
  end
  
  def current_project
    Project.find_by_id(cookies.signed[:open_project])||Project.first
  end
  
   def phases
    Defaultphase.all
  end
  
  def empty_display(entity)
      ret="<p id='empty_entity'>You have not yet created a "+ entity.to_s.singularize+ "#{link_to ". Create it here", :controller=>"#{entity}",:action=>"new"}</p>"
      ret.html_safe
  end
  
  def priority_name(index)
      case index
      
      when 0
         ret = "<font color='green'>Lowest</font>"
      when 1
         ret = "<font color='green'>Low</font>"
      when 2
         ret ="<font color='yellow'>Medium</font>"
      when 3
         ret = "<font color='red'>High</font>"
      when 4
         ret = "<font color='red'>Urgent!</font>"
      else
         ret = "<font color='red'>Undefined</font>"
      end
  ret.html_safe
   end
def status_name(index)
      case index     
      when 0
         ret = "Not started"
      when 1
         ret = "In Progress"
      when 2
         ret = "Nearing Completion"
      when 3
          ret = "Completed"
     
      else
         ret = "Not Started"
      end
  ret.html_safe
   end
   
 def encodings
   if !current_project.metum.stream_xml.nil?
   @doc = Nokogiri::XML(current_project.metum.stream_xml)
    @encodings=[]
    @checked=[]
    @doc.xpath("//type").each_with_index do |type,index|
      @checked[index]=type.xpath("name").attr('checked')
      @enc=[]
      type.xpath("encoding").each do |e|
         @enc<<e.text
      end
      @encodings[index]={type.xpath("name").text=>@enc}     
    end
    ret=@encodings 
    else
      ret=nil
    end
   end 
    
  def checked
    @doc = Nokogiri::XML(current_project.metum.stream_xml)
    @encodings=[]
    @checked=[]
    
    @doc.xpath("//type").each_with_index do |type,index|
      @checked[index]=type.xpath("name").attr('checked').value
      @enc=[]
      type.xpath("encoding").each do |e|
         @enc<<e.text
     end
      @encodings[index]={type.xpath("name").text=>@enc}
    end
    ret=@checked
  end
  
  def sequences
    seq=[]
    
  encodings.each_with_index do |e,i|
  if checked[i].to_bool
    seq<<[encodings[i].keys.first,encodings[i].keys.first]
  end
 end
 ret=seq
 end
end