module UsersHelper
  def gravatar_for(user, options={:size=>50})
    gravatar_image_tag(user.email.downcase, :alt=>user.name,
                                            :class=>"gravatar",
                                            :gravatar=>options)
  end
  
    def display_users(users)
           ret = '<ul CLASS ="mktree">'
     for category in categories
       if category.parent_id == nil
      ret += "<li>"
      ret += link_to category.name, category
      ret += "&nbsp;&nbsp;"
      

      if category.children.size >0 && category_owner_children(category) == 1
       ret += find_all_subcategories(category)
       end
      ret += "</li>"
    
       end
       
     end
     ret += "</ul>"
     ret.html_safe
    end
end
