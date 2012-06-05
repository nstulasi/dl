class MetaController < ApplicationController
  # GET /meta
  # GET /meta.json
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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @metum }
    end
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
 end
 
 def generate_structure
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
   @structure.structure_xml=builder.to_xml
   @structure.save!
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
end
