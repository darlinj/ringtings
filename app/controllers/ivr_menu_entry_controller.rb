class IvrMenuEntryController < ApplicationController
  def destroy
    callplan_id = IvrMenuEntry.find(params[:id].to_i).ivr_menu.action.callplan.id
    IvrMenuEntry.destroy params[:id].to_i
    if signed_in?
      redirect_to callplan_path(callplan_id)
    else
      redirect_to demo_callplan_path(callplan_id)
    end
  end
end

