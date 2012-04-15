module ApplicationHelper
  #return title on a per-page basis
  def title
    base_title = "RoR"
    if @title.nil?
      base_title
    else
      "#{base_title}|#{@title}"
    end
  end
  def logo
    image_tag("green_2.jpg", :alt=>"Sample app", :class =>'round')
  end
  
 def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page=>nil), {:class => css_class}
  end
  
  def current_project
    Project.find_by_id(cookies.signed[:open_project])||nil
  end
end
