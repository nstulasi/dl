class ProjectsController < ApplicationController
    helper_method :sort_column, :sort_direction
    before_filter :require_login
  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page=>params[:page])
    #Variable open_proejct just stores the name of the currently open project
    @open_project = current_project.name if current_project 
     respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
    cookies.permanent.signed[:open_project] = @project.id
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project  }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])
    respond_to do |format|
      if @project.save
        @metum = Metum.new
        @metum.project_id=@project.id
        @metum.save!
        @project.users<<current_user
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
        cookies.permanent[:open_project] = @project.id
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    cookies.delete(:open_project)
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :ok }
    end
  end
  
  def withdraw
    user_delegations=current_project.delegations.find(:all,:conditions=>["id IN (?)",current_user.delegations.collect(&:id)])
    Delegation.destroy_all(['id IN (?)',user_delegations.collect(&:id)])
    cookies.delete(:open_project)
    redirect_to projects_path
  end

  private
   def sort_column
    Phase.column_names.include?(params[:sort])? params[:sort] : "name"
   end
   def sort_direction
    %w[asc desc].include?(params[:direction])? params[:direction] : "asc"
   end
   private
   def require_login
    deny_access unless signed_in?    
   end
end
