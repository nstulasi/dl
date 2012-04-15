class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :admin_user , :only => :destroy
  
  def new
    @title = "Sign up"
    @user = User.new 
    1.times{@user.delegations.build} if !params[:project_user].nil?
    #2.times{@user.delegations.build.build_project}  if !params[:project_user].nil?
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
    #and responsibilities and so we uniquefy it. 
    @proj_users = current_project.users.uniq
    

  end
  
  def show
    @user=User.find(params[:id])
    @title=@user.name
  end
  
  def create
    if User.find_by_id(params[:user][:id]).nil?
      @user = User.new(params[:user]) 
    else
      @user=User.find_by_id(params[:user][:id])
    end
    #@current_user= User.find_by_id(params[:user][:id])
    #current_project.delegations<<@current_user.delegations.create(params[:user][:delegations_attributes][0])
    #current_project.users<<@user=User.create(params[:user])
    #@user.project_user = params[:user][:delegations_attributes].nil?
    if @user.save #&& @user.project_user.nil?
      @user.update_attributes(params[:user]) if !User.find_by_id(params[:user][:id]).nil?
      #sign in only if registered.Got to add validation!!
      #sign_in @user 
      flash[:success] = "Welcome to the Sample App"
      redirect_to @user
    #elsif !@user.project_user.nil?
      #@delegation = Delegation.create(params[:user][:delegations_attributes])
     # redirect_to projects_path
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
   if @user.update_attributes(params[:user])
     flash[:success]="Profile updated"
     redirect_to @user
   else
     @title = 'Edit user'
     render 'edit'
   end
 end
 
 def admin_user
   redirect_to(root_path) unless current_user.admin?
 end
 
 private
 def authenticate
   deny_access unless signed_in?
 end
end
