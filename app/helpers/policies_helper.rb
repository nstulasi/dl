module PoliciesHelper
    def current_project_policies
    current_project.policies.each do |d|
     return d
    end
  end
end
