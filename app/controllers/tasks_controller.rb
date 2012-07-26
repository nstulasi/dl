class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :require_login
  
 
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = current_project_tasks unless current_project.nil?
    pdf = TaskPdf.new(@tasks, view_context)
    respond_to do |format|
     format.html # index.html.erb
    format.json { render json: @tasks }
    format.csv { send_data @tasks.get_csv }
    format.xls
    format.pdf {
      send_data  filename: "tasks.pdf",
                            type: "application/pdf",
                            disposition: "inline"
                            } 
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
    puts params
    sleep(5)
    @task = Task.new(:name=>params[:task][:name],:status=>params[:task][:status])
    respond_to do |format|
      if @task.save 
        @task.update_attribute(:project_id,current_project.id)
        @del=[]
        #Saving a task under a user.
        if !params[:user].nil?
          @del = Delegation.find(:all,:conditions=>["user_id IN (?)", params[:user][:id].collect])
                    
          @del.uniq.each do |d|
            @a=Assignment.new(:delegation_id=>d,:task_id=>@task.id)
             @a.save            
          end
          puts @del.uniq
         sleep(5)
          #Updating the delgation id cause that isnot automatically assigned to teh assignment. 
          @task.assignments.each_with_index do |a,i|
          a.update_attribute(:delegation_id,@del[i].id) unless @del[i].nil?
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
    @task.update_attributes(params[:task])
    puts params
    sleep(2)
    @a=[]
    if !params[:user].nil?
          @del = Delegation.all(:select=>"id",:conditions=>["user_id IN (?)", params[:user][:id].collect]).collect(&:id)

          @del.each do |d|
            @a<<Assignment.find_or_create_by_delegation_id_and_task_id(d,@task.id)
            @a=@a.flatten           
          end
          
          puts @a
          sleep(5)
          
          a_add= @a - @task.assignments#add
          a_des= @task.assignments - @a#delete
          puts "des"
          puts a_des
          sleep(5)
          
          a_des.each do |i|
            i.destroy
          end
          
          #puts @del.uniq
         #sleep(5)
          #Updating the delgation id cause that isnot automatically assigned to teh assignment. 
          #@task.assignments.each_with_index do |a,i|
          #a.update_attribute(:delegation_id,@del[i].id) unless @del[i].nil?
          #end
    else
      @all=Assignment.all(:conditions=>["task_id=?",@task.id])
          @all.each do |a|
            a.destroy
          end
    end

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
     @errors=[]
    if params[:file].nil?
      @errors<<"Specify an XML file to import"
      flash[:notice]=@errors
    else
      xsd = Nokogiri::XML::Schema(File.read("project-tasks.xsd"))
      doc = Nokogiri::XML(params[:file].read)
      xsd.validate(doc).each do |error|
          @errors<<error
      end
  
      if !@errors.empty?
        puts @errors 
        sleep(10)
        flash[:notice] = @errors
      end
      if !params[:file].nil? && @errors.empty?
        doc.xpath("//task").each do |task|
          task_name = task.xpath("name").text
          task_status = task.xpath("status").text
          task_priority = task.xpath("priority").text
          task_start_date = task.xpath("start_date").text
          task_end_date =  task.xpath("end_date").text
          Task.create(:name=>task_name,:status=>task_status,:priority=>task_priority,:start_at=>task_start_date,:end_at=>task_end_date,:project_id=>current_project.id)
          flash[:notice]="Tasks successfully created"
          end
      end
    end
    redirect_to :back
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
