class SocietiesController < ApplicationController
  # GET /societies
  # GET /societies.json
  def index
    @societies = Society.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @societies }
    end
  end

  # GET /societies/1
  # GET /societies/1.json
  def show
    @society = Society.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @society }
    end
  end

  # GET /societies/new
  # GET /societies/new.json
  def new
    @society = Society.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @society }
    end
  end

  # GET /societies/1/edit
  def edit
    @society = Society.find(params[:id])
  end

  # POST /societies
  # POST /societies.json
  def create
    @society = Society.new(params[:society])

    respond_to do |format|
      if @society.save
        format.html { redirect_to @society, notice: 'Society was successfully created.' }
        format.json { render json: @society, status: :created, location: @society }
      else
        format.html { render action: "new" }
        format.json { render json: @society.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /societies/1
  # PUT /societies/1.json
  def update
    @society = Society.find(params[:id])

    respond_to do |format|
      if @society.update_attributes(params[:society])
        format.html { redirect_to @society, notice: 'Society was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @society.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /societies/1
  # DELETE /societies/1.json
  def destroy
    @society = Society.find(params[:id])
    @society.destroy

    respond_to do |format|
      format.html { redirect_to societies_url }
      format.json { head :ok }
    end
  end
end
