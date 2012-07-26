class EventsController < ApplicationController
  before_filter :require_login
  # GET /events
  # GET /events.json
  def index
    @month = (params[:month] || (Time.zone || Time).now.month).to_i
    @year = (params[:year] || (Time.zone || Time).now.year).to_i
    @shown_month = Date.civil(@year, @month)
    #Displaying only current project's events
    if current_project.nil?
      @event_strips = Event.event_strips_for_month(@shown_month)
    else
      @event_strips = current_project.events.event_strips_for_month(@shown_month) if !current_project.nil?
    end 
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
      format.csv { send_data @events.get_csv }
      format.xls
      format.pdf {
        send_data  filename: "events.pdf",
                              type: "application/pdf",
                              disposition: "inline"
                              } 
    end 
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event } 
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event=Event.new  
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project.events }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.create(params[:event])
    respond_to do |format|
      if @event.save
        current_project.events<<@event
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end
  private
   def require_login
    deny_access unless signed_in?    
  end 
end
