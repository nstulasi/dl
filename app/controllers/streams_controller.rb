class StreamsController < ApplicationController
  # GET /streams
  # GET /streams.json
  def index
    @streams = Stream.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @streams }
    end
  end

  # GET /streams/1
  # GET /streams/1.json
  def show
    @stream = Stream.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @stream }
    end
  end

  # GET /streams/new
  # GET /streams/new.json
  def new
    @stream = Stream.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @stream }
    end
  end

  # GET /streams/1/edit
  def edit
    @stream = Stream.find(params[:id])
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
 @stream= current_project.stream
 @stream.xmlcontent=builder.to_xml
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
   @structure= current_project.structure
   @structure.xmlcontent=builder.to_xml
   @structure.save!
   end
  
  # POST /streams
  # POST /streams.json
  def create
    @content = params[:content]

    respond_to do |format|
      if @stream.save
        format.html { redirect_to @stream, notice: 'Stream was successfully created.' }
        format.json { render json: @stream, status: :created, location: @stream }
      else
        format.html { render action: "new" }
        format.json { render json: @stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /streams/1
  # PUT /streams/1.json
  def update
    @stream = Stream.find(params[:id])

    respond_to do |format|
      if @stream.update_attributes(params[:stream])
        format.html { redirect_to @stream, notice: 'Stream was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /streams/1
  # DELETE /streams/1.json
  def destroy
    @stream = Stream.find(params[:id])
    @stream.destroy

    respond_to do |format|
      format.html { redirect_to streams_url }
      format.json { head :ok }
    end
  end
end
