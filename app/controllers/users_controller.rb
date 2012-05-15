class UsersController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :admin_user , :only => :destroy
  
  def new
    @title = "Sign up"
    @user = User.new
    #Creating a project user if unregistered user needs to be created. 
    1.times{@user.delegations.build} unless params[:project_user].nil?
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
    #Returning all users assigned to the currently open project, using the Delegations model as the join
    #The results may contain duplicates as a user may have multiple entries in delegations depending on his roles
    #and responsibilities and so we return uniwue delegations.
    @proj_users = current_project.users.uniq unless current_project.nil?
  end
  
  def show
    @user=User.find(params[:id])
    @title=@user.name
  end
  
  def create
    #Put a conditional ? : statement 
    if User.find_by_id(params[:user][:id]).nil? 
       @user = User.new(params[:user])
       @user.project_user=true 
    else
        @user=User.find_by_id(params[:user][:id])
        @user.project_user=false
    end 
    #If User.save and user is not a newly created project user 
    if @user.save && @user.project_user.nil?
      sign_in @user 
      flash[:success] = "Welcome to the Sample App"
      redirect_to @user
      # else if user is a project_user
     elsif @user.save && !@user.project_user.nil?
          @user.update_attributes(params[:user]) if !User.find_by_id(params[:user][:id]).nil?
          #Updating delegations table with the current_proejct id
          @user.delegations.each do |d|
            d.update_attribute(:project_id,current_project.id)
          end
          redirect_to projects_path
      else
        @title="Sign up"
        render 'new'
    end
  end
  
 def edit
   @user = User.find(params[:id])
   @title = "Edit user"
 end
 

  def update
    @user = User.find(params[:id])
     @user.update_attributes(params[:user])
     respond_with @user

  end
 
 def admin_user
   redirect_to(root_path) unless current_user.admin?
 end
 
 def mercury_update
 user = User.find(params[:id])
  # Update page
  render text: ""
 end
 
 private
 def authenticate
   deny_access unless signed_in?
 end
end
