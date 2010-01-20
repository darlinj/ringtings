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
    redirect_to callplan_path(params[:id])
  end

  def delete_ivr_menu_entry
    ivr_menu_entry = IvrMenuEntry.find params["ivr_menu_entry_id"].to_i
    callplan = ivr_menu_entry.ivr_menu.action.callplan
    IvrMenuEntry.destroy params["ivr_menu_entry_id"].to_i
    redirect_to callplan_path(callplan.id)
  end

  private
  def set_tab
    @tab="callplan"
  end
end
