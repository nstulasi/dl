module ProjectsHelper
  def project_cookie(project_id)
    cookies.permanent.signed[:open_project]=project_id
  end
end
