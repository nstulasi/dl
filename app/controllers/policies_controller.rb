class PoliciesController < ApplicationController
  # GET /policies
  # GET /policies.json
  def index
    @policies = Policy.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @policies }
    end
  end

  # GET /policies/1
  # GET /policies/1.json
  def show
    @policy = Policy.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @policy }
    end
  end

  # GET /policies/new
  # GET /policies/new.json
  def new
    @policy = Policy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @policy }
    end
  end

  # GET /policies/1/edit
  def edit
    @policy = Policy.find(params[:id])
  end

  # POST /policies
  # POST /policies.json
  def create
    @policy = Policy.new(params[:policy])

    respond_to do |format|
      if @policy.save
        format.html { redirect_to @policy, notice: 'Policy was successfully created.' }
        format.json { render json: @policy, status: :created, location: @policy }
      else
        format.html { render action: "new" }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /policies/1
  # PUT /policies/1.json
  def update
    @policy = Policy.find(params[:id])

    respond_to do |format|
      if @policy.update_attributes(params[:policy])
        format.html { redirect_to @policy, notice: 'Policy was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /policies/1
  # DELETE /policies/1.json
  def destroy
    @policy = Policy.find(params[:id])
    @policy.destroy

    respond_to do |format|
      format.html { redirect_to policies_url }
      format.json { head :ok }
    end
  end
end
