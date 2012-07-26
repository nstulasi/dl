class TaskPdf < Prawn::Document
  def initialize(task, view)
    super(top_margin: 70)
    @task = task
    @view = view
    title
    line_items
  end
  
  def title
    text "Task List", size: 30, style: :bold
  end
  
  def line_items
    move_down 20
    table line_item_rows do
      row(0).font_style = :bold
      column(0).width= 145
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def line_item_rows
    [["Task name", "Priority","Status", "Start date", "End date"]] +
    Task.all.map do |item|
      [item.name, priority_task(item.priority.to_i), status_name(item.status.to_i), to_date(item.start_at), to_date(item.end_at)]
    end
  end
  
  def status_name(index)
      case index     
      when 0
         ret = "Not started"
      when 1
         ret = "In Progress"
      when 2
         ret = "Nearing Completion"
      when 3
          ret = "Completed"
     
      else
         ret = "Undefined"
      end
  ret.html_safe
   end
   
  def priority_task(index)
      case index
      when 0
         ret = "Lowest"
      when 1
         ret = "Low"
      when 2
         ret = "Medium"
      when 3
         ret = "High"
      when 4
         ret = "Urgent"
      else
         ret = "Undefined"
      end
  ret.html_safe
   end
   
   def to_date(date)
     date.strftime("%F")
   end
end