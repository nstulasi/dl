class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :require_login

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = current_project_tasks unless current_project.nil?
    respond_to do |format|
     format.html # index.html.erb
    format.json { render json: @tasks }
    end   
  end

  def view_calendar
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Task.event_strips_for_month(@shown_month)
 
  end
  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new
    #Building 3 task assignments i.e. 3 users t which the taks is given.
    3.times{@task.assignments.build}
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])
    respond_to do |format|
      if @task.save 
        @task.update_attribute(:project_id,current_project.id)
        #Saving a task under a user.
        if !params[:user].nil?
          @del = Delegation.find_by_user_id(params[:user][:id])
          #Updating the delgation id cause that isnot automatically assigned to teh assignment. 
          @task.assignments.each do |a|
          a.update_attribute(:delegation_id,@del.id) unless @del.nil?
          end
        end
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :ok }
    end
  end
  
  def validate(document_path, schema_path, root_element)
    schema = Nokogiri::XML::Schema(File.read(schema_path))
    document = Nokogiri::XML(File.read(document_path))
    schema.validate(document.xpath("//#{root_element}").to_s)
  end
  
  def rake_tasks
    #validate(, 'schema.xdf', 'root').each do |error|
     #    puts error.message
      #   sleep(10)
    #end
    puts params[:file].read
    sleep(10)
    contents='<?xml version="1.0" encoding="utf-8"?>
<root>
  <task>
    <name>Architecture design and enhancement </name>
    <status>1</status>
    <priority>2</priority>
    <site> PS </site>
    <project_id>1</project_id>
    <start_date> 2012-05-16 </start_date>
    <end_date> 2012-05-18 </end_date>
  </task>
  <task>
    <name>Architecture design and enhancement </name>
    <status>1</status>
    <priority>2</priority>
    <site> PS </site>
    <project_id>1</project_id>
    <start_date> 2012-05-16 </start_date>
    <end_date> 2012-05-18 </end_date>
  </task>
</root>'

    system "start rake fetch_tasks(contents)"
    redirect_to tasks_url 
  end
  
 private
 def sort_column
   Task.column_names.include?(params[:sort])? params[:sort] : "name"
 end
  def sort_direction
   %w[asc desc].include?(params[:direction])? params[:direction] : "asc"
 end
 
 def require_login
    deny_access unless signed_in?    
  end 

end
