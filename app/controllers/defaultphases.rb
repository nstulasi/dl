 class DefaultphasesController < ApplicationController
  def show
    @defaultphase = Defaultphase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @defaultphase, handlers: [:rabl]}
    end
  end
 end