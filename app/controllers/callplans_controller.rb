class CallplansController < ApplicationController
  before_filter :authenticate
  before_filter :set_tab

  def show
    @callplan = Callplan.find(params[:id].to_i)
  end

  def update
    @callplan = Callplan.find(params[:id].to_i)
    if @callplan.update_attributes(params[:callplan])
      flash[:notice] = "Callplan sucessfully saved"
    else
      flash[:notice] = "Callplan failed to save"
    end
    respond_to do |format|
      format.html { render :template =>"callplans/show" }
    end
  end

  private
  def set_tab
    @tab="callplan"
  end
end
