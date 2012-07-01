class PoliciesController < ApplicationController
  before_filter :require_login
  # GET /policies
  # GET /policies.json

  
  def index
    @policies = current_project.policies.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @policies }
      format.xml
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
    d_id=params[:default][:id]
    #puts "*******"
    #puts params
    #sleep(10)
    respond_to do |format|
      if @policy.save
        if !d_id.nil?
            @policy.update_attribute(:default_policy_id,d_id)
        end
        @policy.update_attribute(:project_id,current_project.id)
        format.html { redirect_to :back, notice: 'Policy was successfully created.' }
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
    d_id=params[:default][:id]
    
    respond_to do |format|
      if @policy.update_attributes(params[:policy])
        if !d_id.nil?
            @policy.update_attribute(:default_policy_id,d_id)
        end
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
      format.html { redirect_to default_policies_url }
      format.json { head :ok }
    end
  end
  
  private
   def require_login
    deny_access unless signed_in?    
  end 
end
