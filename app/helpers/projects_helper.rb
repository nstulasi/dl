module ProjectsHelper
  def project_cookie(project_id)
    cookies.permanent.signed[:open_project]=project_id
  end
   def remove_user_from_project(user)
        current_project.users.delete(user)
   end
end
