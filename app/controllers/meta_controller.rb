class MetaController < ApplicationController
  # GET /meta
  # GET /meta.json
  @formerrors=[]
  def index
    @meta = Metum.all
   
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @meta }
    end
  end

  # GET /meta/1
  # GET /meta/1.json
  def show
    @metum = Metum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @metum }
    end
  end

  # GET /meta/new
  # GET /meta/new.json
  def new
    @metum = Metum.new
      @struc_errors=params[:struc_errors]
      @soc_errors=params[:soc_errors]
     if !current_project.nil?
       gon.scenario=current_project.metum.scenario_xml
     else
       gon.scenario=""
     end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @metum }
    end
  end
  
  def current_scenarios
  end
  
  def generate_stream
    type=["character","text","audio","video","image","program"]
    type_encoding=["character_encoding","text_encoding","audio_encoding","video_encoding","image_encoding","program_encoding"]
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.streams{
     xml.content{
       xmler(xml,type,type_encoding)
     }
    }
  end
 @stream= current_project.metum
 @stream.stream_xml=builder.to_xml
 @stream.save!
 redirect_to :action=>'new'
 end
 
 def generate_structure
   @formerrors=[]
  # validate the inputs:
  if params[:name].nil?||params[:name].empty?
      @formerrors << "Name must be longer than 3 characters"
  end 
  if params[:sequences].nil?
      @formerrors << "Enter atleast one type of sequence for the collection"
  end 
  if @formerrors.nil?||@formerrors.empty?
    # user got it right, do whatever you really want to do with the data
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.structures{
       xml.collection{
        xml.name{xml.text params[:name]}
        xml.categorization{
         xml.type{xml.text params[:type]}
         }
         xml.sequences{
           params[:sequences].each do |s|
           xml.sequence{xml.text s}
           end
         }
       }
      }
    end
   @structure= current_project.metum
   @doc = Nokogiri::XML(current_project.metum.structure_xml)
   if params[:id].to_i==1
     @structure.structure_xml=builder.to_xml
     @structure.save!
   else
     if !@doc.xpath("//collection")[params[:id].to_i].nil? 
        @doc.xpath("//collection")[params[:id].to_i].replace(Nokogiri::XML(builder.to_xml).xpath("//collection"))
     else
       if !@doc.xpath("//collection").empty?
        @doc.xpath("//collection").after(Nokogiri::XML(builder.to_xml).xpath("//collection"))
       else #First record
        @doc=Nokogiri::XML(builder.to_xml)
        end
      end
       @structure.structure_xml=@doc.to_xml
      @structure.save!
    end
   redirect_to :action=>'new'
  else
    params[:struc_errors]=@formerrors
    redirect_to new_metum_path(Metum.new,:struc_errors=>params[:struc_errors])
  end      
end

def generate_space
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.spaces{
       xml.indexingTool{
        xml.name{xml.text params[:indexing_name]}
        xml.ui{
         xml.ui_language{xml.text params[:ui_lang]}
         xml.ui_presentation{xml.text params[:ui_displang]}
         }
         xml.ir_model{
           xml.retrieval_space{xml.text params[:ir_space]}
           xml.stemming_algorithm{xml.text params[:stemming_algo]}
           xml.stopwords{xml.text params[:stopwords]}
         }
       }
      }
    end
   @space= current_project.metum
   @space.space_xml=builder.to_xml
   @space.save!
   redirect_to :action=>'new'
 end

 def generate_scenario
   @scenario = current_project.metum
   @scenario.scenario_xml=params[:xml]
   @scenario.save!
   end
   
def generate_society
   @formerrors=[]
  # validate the inputs:
  if params[:group_name].nil?||params[:group_name].empty?
      @formerrors << "Name must be longer than 3 characters" if (params[:group_name].length < 3)
  end 
  @noservice=true
  services.each_with_index do |s,i|
      if !params[s].nil?
        @noservice=false
      end
    end
  if @noservice
      @formerrors << "Enter atleast one type of service the user participates in"
  end 
  if @formerrors.nil?||@formerrors.empty?
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.societies{
       xml.group{
        xml.name{xml.text params[:group_name]}
        xml.services{
           service_xmler(xml)
         }
        xml.goals{xml.text params[:goals]}
       }
      }
    end
   @society= current_project.metum
   @doc = Nokogiri::XML(current_project.metum.society_xml)
   if !@doc.xpath("//group")[params[:id].to_i].nil? 
      @doc.xpath("//group")[params[:id].to_i].replace(Nokogiri::XML(builder.to_xml).xpath("//group"))
   else
     if !@doc.xpath("//group").empty?
      @doc.xpath("//group").after(Nokogiri::XML(builder.to_xml).xpath("//group"))
     else #First record
      @doc=Nokogiri::XML(builder.to_xml)
     end
   end
   @society.society_xml=@doc.to_xml
   @society.save!
   redirect_to new_metum_path
   else
     params[:soc_errors]=@formerrors
    redirect_to new_metum_path(Metum.new,:soc_errors=>params[:soc_errors])
  end      
 end
   
   
  # GET /meta/1/edit
  def edit
    @metum = Metum.find(params[:id])
  end

  # POST /meta
  # POST /meta.json
  def create
    @metum = Metum.new(params[:metum])

    respond_to do |format|
      if @metum.save
        format.html { redirect_to @metum, notice: 'Metum was successfully created.' }
        format.json { render json: @metum, status: :created, location: @metum }
      else
        format.html { render action: "new" }
        format.json { render json: @metum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /meta/1
  # PUT /meta/1.json
  def update
    @metum = Metum.find(params[:id])

    respond_to do |format|
      if @metum.update_attributes(params[:metum])
        format.html { redirect_to @metum, notice: 'Metum was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @metum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meta/1
  # DELETE /meta/1.json
  def destroy
    @metum = Metum.find(params[:id])
    @metum.destroy

    respond_to do |format|
      format.html { redirect_to meta_url }
      format.json { head :ok }
    end
  end
  
  def soc_del
    puts "********in del"
    puts params[:id]
    @society= current_project.metum
    @doc = Nokogiri::XML(current_project.metum.society_xml)
    @doc.xpath("//group")[params[:id].to_i].remove
    if @doc.xpath("//group").empty?
      @doc.xpath("//societies")[0].remove
    end
    @society.society_xml=@doc.to_xml
    @society.save!
    redirect_to new_metum_path
  end
  
    def struc_del
    puts "********in del"
    puts params[:id]
    @structure= current_project.metum
    @doc = Nokogiri::XML(current_project.metum.structure_xml)
    @doc.xpath("//collection")[params[:id].to_i].remove
    if @doc.xpath("//collection").empty?
      @doc.xpath("//structures")[0].remove
    end
    @structure.structure_xml=@doc.to_xml
    @structure.save!
    redirect_to new_metum_path
  end
end
