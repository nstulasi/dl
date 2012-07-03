class ResourcesController < ApplicationController
  # GET /resources
  # GET /resources.json
  require 'open-uri'
  def index
    @resourceable = find_resourceable
    @resources = @resourceable.resources
        respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @resources.collect { |p| p.to_jq_upload }.to_json
}
    end
  end

  # GET /resources/1
  # GET /resources/1.json
  def show
    @resource = Resource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resource }
    end
  end

  # GET /resources/new
  # GET /resources/new.json
  def new
    @resource = Resource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @resource }
    end
  end

  # GET /resources/1/edit
  def edit
    @resource = Resource.find(params[:id])
  end

  def validate(document_path, schema_path, root_element)
    schema = Nokogiri::XML::Schema(File.read(schema_path))
    document = Nokogiri::XML(File.read(document_path))
    schema.validate(document.xpath("//#{root_element}").to_s)
  end
  
  def rake_tasks
    #validate(, 'schema.xdf', 'root').each do |error|
     #    puts error.message
      #   sleep(10)
    #end
    system "start rake fetch_tasks(#{params[:file_file_name]})"
    redirect_to tasks_url 
  end
  # POST /resources
  # POST /resources.json
  def create
     
      @resourceable = find_resourceable
      @resource = @resourceable.resources.build(params[:resource])
    respond_to do |format|
      if @resource.save
          format.html {  
          render :json => [@resource.to_jq_upload].to_json, 
          :content_type => 'text/html',
          :layout => false
            }
        format.json {  
          render :json => [@resource.to_jq_upload].to_json     
        } 
      else
        render :json => [{:error => "custom_failure"}], :status => 304
      end
    end
  end

  # PUT /resources/1
  # PUT /resources/1.json
  def update
    @resource = Resource.find(params[:id])

    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        format.html { redirect_to @resource, notice: 'Resource was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource = Resource.find(params[:id])
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to resources_url }
      format.json { head :ok }
    end
  end
  
  def find_resourceable
  params.each do |name, value|
    if name =~ /(.+)_id$/
      return $1.classify.constantize.find(value)
    end
  end
  nil
end
end
