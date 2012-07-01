class DefaultPoliciesController < ApplicationController
  # GET /default_policies
  # GET /default_policies.json
  def index
    @default_policies = DefaultPolicy.paginate(:page => params[:page],:per_page=>5)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @default_policies }
    end
  end

  # GET /default_policies/1
  # GET /default_policies/1.json
  def show
    @default_policy = DefaultPolicy.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @default_policy }
    end
  end

  # GET /default_policies/new
  # GET /default_policies/new.json
  def new
    @default_policy = DefaultPolicy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @default_policy }
    end
  end

  # GET /default_policies/1/edit
  def edit
    @default_policy = DefaultPolicy.find(params[:id])
  end

  # POST /default_policies
  # POST /default_policies.json
  def create
    @default_policy = DefaultPolicy.new(params[:default_policy])

    respond_to do |format|
      if @default_policy.save
        format.html { redirect_to @default_policy, notice: 'Default policy was successfully created.' }
        format.json { render json: @default_policy, status: :created, location: @default_policy }
      else
        format.html { render action: "new" }
        format.json { render json: @default_policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /default_policies/1
  # PUT /default_policies/1.json
  def update
    @default_policy = DefaultPolicy.find(params[:id])

    respond_to do |format|
      if @default_policy.update_attributes(params[:default_policy])
        format.html { redirect_to @default_policy, notice: 'Default policy was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @default_policy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /default_policies/1
  # DELETE /default_policies/1.json
  def destroy
    @default_policy = DefaultPolicy.find(params[:id])
    @default_policy.destroy

    respond_to do |format|
      format.html { redirect_to default_policies_url }
      format.json { head :ok }
    end
  end
end
