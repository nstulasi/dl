class UsersController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :admin_user , :only => :destroy, :dependent => :destroy
  
  def new
    @title = "Sign up"
    @user = User.new
    #Creating a project user if unregistered user needs to be created. 
    1.times{@user.delegations.build} unless params[:project_user].nil?
  end
  
  def rake_users
     @errors=[]
    if params[:file].nil?
      @errors<<"Specify an XML file to import"
      flash[:notice]=@errors
    else
      xsd = Nokogiri::XML::Schema(File.read("project-users.xsd"))
      doc = Nokogiri::XML(params[:file].read)
      xsd.validate(doc).each do |error|
          @errors<<error
      end
  
      if !@errors.empty?
        flash[:notice] = @errors
      end

      if !params[:file].nil? && @errors.empty?
        doc.xpath("//user").each do |user|
          name = user.xpath("name").text
          email = user.xpath("email").text
          webpage = user.xpath("webpage").text
          number =  user.xpath("number").text
          @user=User.new(:name=>name,:email=>email,:webpage=>webpage,:number=>number,:role=>"blee")
          @user.project_user=true
          if @user.save
            flash[:notice]="Users created"
          else
            flash[:notice]=@user.errors 
          end
          sleep(5)
          end
      end
    end
    
    redirect_to :back
  end
  
  
  def destroy
    puts params
    sleep(10)
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
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @proj_users }
      format.csv { send_data @proj_users.get_csv }
      format.xls
      format.pdf {
        send_data  filename: "users.pdf",
                              type: "application/pdf",
                              disposition: "inline"
                              } 
    end 
  end
  
  def show
    @user=User.find(params[:id])
    @title=@user.name
  end
  
  def create
    puts params
    sleep(5)
    #Creating/Registering new user
    if params[:project_user].nil?
     @user = User.new(params[:user])
     if @user.save 
         puts "creating new user"
         sleep(5)
          signin @user
          cookies.delete(:open_project) 
        flash[:success] = "Welcome to the tool"
        redirect_to @user
            
        else
          puts "couldnt create new user"
          sleep(5)
          @title="Sign up"
          render 'new'
      end
     else
    #Creating Project user(Drop-down/new one)
    #if no user is chosen from drop-down
    if params[:user][:id].empty?
      redirect_to :back
      puts "bad"
      sleep(5)
    end
    #Put a conditional ? : statement 
    if params[:project_user]
      if User.find_by_id(params[:user][:id]).nil?
        puts "creating project user"
        #sleep(5)
         @user = User.new(params[:user])
          @user.project_user=true
          if @user.save
            @user.delegations.each do |d|
            d.update_attribute(:project_id,current_project.id)
            end
         end
      else
        puts "found user"
        #sleep(5)
          @user=User.find_by_id(params[:user][:id])
          @user.project_user=true
          @user.update_attributes(params[:user])
          #Updating delegations table with the current_proejct id
          @user.delegations.each do |d|
            d.update_attribute(:project_id,current_project.id)
          end
          redirect_to projects_path
      end 
    end
  end#big if

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
