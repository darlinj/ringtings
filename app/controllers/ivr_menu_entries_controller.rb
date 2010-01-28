class IvrMenuEntriesController < ApplicationController
  def create
    ivr_menu_entry = IvrMenuEntry.new :type => params['type'], :action => 'menu-exec-app', :digits => "1", :system_param_part => "say", :user_param_part => "type your announcement here", :prompt => "Synthetic vocie says:"
    ivr_menu = IvrMenu.find(params['ivr_menu_id'].to_i)
    if ivr_menu.ivr_menu_entries
      ivr_menu_entry.digits = (ivr_menu.ivr_menu_entries.map {|e| e.digits}.max.to_i+1).to_s
    end
    ivr_menu_entry.ivr_menu=ivr_menu
    ivr_menu_entry.save
  end

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

