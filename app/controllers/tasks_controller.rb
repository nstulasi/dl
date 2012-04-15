class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = current_tasks
    @tasks = @tasks.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page=>params[:page])unless @tasks.nil?
   
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
        @del = Delegation.find_by_user_id(params[:user][:id])
        @task.assignments.each do|a|
        a.update_attribute(:delegation_id,@del.id) unless @del.nil?
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
  
  
 private
 def sort_column
   Task.column_names.include?(params[:sort])? params[:sort] : "name"
 end
  def sort_direction
   %w[asc desc].include?(params[:direction])? params[:direction] : "asc"
 end

end
