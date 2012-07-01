   desc "Fetch tasks"
   task :fetch_tasks => :environment do
   require 'nokogiri'
    @doc = Nokogiri::XML(file)
    @doc.xpath("//task").each do |task|
      task_name = task.xpath("name").text
      task_status = task.xpath("status").text
      task_priority = task.xpath("priority").text
      task_site = task.xpath("site").text
      task_project_id = task.xpath("project_id").text
      task_start_date = task.xpath("start_date").text
      task_end_date =  task.xpath("end_date").text
      Task.create(:name=>task_name,:status=>task_status,:priority=>task_priority,:site=>task_site,:project_id=>task_project_id,:start_at=>task_start_date,:end_at=>task_end_date)
    end
    redirect_to tasks_url
  end

