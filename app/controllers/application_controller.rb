class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include TasksHelper
  include ApplicationHelper
  include PhasesHelper
  include MetaHelper
end
