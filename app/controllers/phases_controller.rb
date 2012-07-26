class PhasesController < ApplicationController
  before_filter :require_login
  # GET /phases
  # GET /phases.json
  def index
    @phases = current_project.phases.all unless current_project.nil?
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @phases }
      format.csv { send_data @phases.get_csv }
      format.xls
      format.pdf {
        send_data  filename: "phases.pdf",
                              type: "application/pdf",
                              disposition: "inline"
                              } 
    end
  end

  # GET /phases/1
  # GET /phases/1.json
  def show
    @phase = Phase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @phase, handlers: [:rabl]}
    end
  end

  # GET /phases/new
  # GET /phases/new.json
  def new
    @phase = Phase.new
     respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @phase }
    end
  end

def rake_phases
     @errors=[]
    if params[:file].nil?
      @errors<<"Specify an XML file to import"
      flash[:notice]=@errors
    else
      xsd = Nokogiri::XML::Schema(File.read("project-phases.xsd"))
      doc = Nokogiri::XML(params[:file].read)
      xsd.validate(doc).each do |error|
          @errors<<error
      end
  
      if !@errors.empty?
        flash[:notice] = @errors
      end

      if !params[:file].nil? && @errors.empty?
        doc.xpath("//phase").each do |phase|
          name = phase.xpath("name").text
          content = phase.xpath("content").text
          start_date = phase.xpath("start_date").text
          end_date =  phase.xpath("end_date").text
          Phase.create(:name=>name,:content=>content,:start=>start_date,:end=>end_date,:project_id=>current_project.id)
          end
      end
    end
    
    redirect_to :back
  end
  # GET /phases/1/edit
  def edit
    @phase = Phase.find(params[:id])
  end

  # POST /phases
  # POST /phases.json
  def create
    @phase = Phase.new(params[:phase])
    current_project.phases<<@phase
    respond_to do |format|
      if @phase.save
        format.html { redirect_to phases_path, notice: 'Phase was successfully created.' }
        format.json { render json: @phase, status: :created, location: @phase }
      else
        format.html { render action: "new" }
        format.json { render json: @phase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /phases/1
  # PUT /phases/1.json
  def update
    @phase = Phase.find(params[:id])

    respond_to do |format|
      if @phase.update_attributes(params[:phase])
        format.html { redirect_to @phase, notice: 'Phase was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @phase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phases/1
  # DELETE /phases/1.json
  def destroy
    @phase = Phase.find(params[:id])
    @phase.destroy

    respond_to do |format|
      format.html { redirect_to phases_url }
      format.json { head :ok }
    end
  end
  
  def make
    params[:phases].each do |p|
      #finding the name of the parent phase in Default Phases
      @parent_phase_id=Defaultphase.find(:first,:conditions=>['name=?',p]).parent_id
      if !@parent_phase_id.nil?
        @parent_phase_name=Defaultphase.find_by_id(@parent_phase_id).name 
        if !@parent_phase_name.nil?
        @phase=Phase.find_or_create_by_name(:project_id=>current_project.id, :name=>p, :parent_id=>Phase.find(:first,:conditions=>["name=?",@parent_phase_name]).id)
        end 
     else
        @phase=Phase.find_or_create_by_name(:project_id=>current_project.id, :name=>p)
     end 
   end
   redirect_to phases_path
   end
   
    def savesort
    neworder = JSON.parse(params[:set])
    prev_item = nil
    neworder.each do |item|
      dbitem = Phase.find(item['id'])
      prev_item.nil? ? dbitem.move_to_root : dbitem.move_to_right_of(prev_item)
      sort_children(item, dbitem) unless item['children'].nil?
      prev_item = dbitem
    end
    Phase.rebuild!
    render :nothing => true
  end
  
    def sort_children(element,dbitem)
    prevchild = nil
    element['children'].each do |child|
      childitem = Phase.find(child['id'])
      prevchild.nil? ? childitem.move_to_child_of(dbitem) : childitem.move_to_right_of(prevchild)
      sort_children(child, childitem) unless child['children'].nil?
      prevchild = childitem
    end
  end
  
   private
   def require_login
    deny_access unless signed_in?    
  end 
end
