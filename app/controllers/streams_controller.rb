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
    @doc = Nokogiri::XML(current_project.stream.xmlcontent.gsub(/\n/,"").gsub(" ",""))
    @encodings0=[]
    
    @doc.xpath("//type").each_with_index do |type,index|
      @enc=[]
      @enc=type.xpath("encoding").to_a()
      puts "******************"
      puts @enc
      sleep(3)
      @encodings0[index]={type.xpath("name").text=>@enc}
      puts "********888"
      puts @encodings0[0]
    end
    @encodings=[]
    @doc.xpath("//encoding").each_with_index do |encoding,index|
      @encodings[index]=encoding.text
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @stream }
    end
  end

  # GET /streams/1/edit
  def edit
    @stream = Stream.find(params[:id])
  end
  
def generate_xml
    type=["Character","Text","Audio","Video","Image","Program"]
    type_encoding=["character_encoding","text_encoding","audio_encoding","video_encoding","image_encoding","program_encoding"]
    builder = Nokogiri::XML::Builder.new do |xml|
    xml.streams{
     xml.content{
       xmler(xml,type,type_encoding)
     }
    }
  end
 @stream= current_project.stream
 puts builder.to_xml
 file = File.new('dir.xml','w')
 @stream.xmlcontent=builder.to_xml
 @stream.save!
 file.puts builder.to_xml
 file.close
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
