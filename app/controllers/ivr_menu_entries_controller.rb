class IvrMenuEntriesController < ApplicationController
  def create
    ivr_menu_entry = Module.const_get(params['type']).new :digits => "1",
      :user_param_part => "type your announcement here",
      :prototype => IvrMenuEntryPrototype.find_by_name(params['type'])
    ivr_menu = IvrMenu.find(params['ivr_menu_id'].to_i)
    if ivr_menu.ivr_menu_entries
      ivr_menu_entry.digits = (ivr_menu.ivr_menu_entries.map {|e| e.digits}.max.to_i+1).to_s
    end
    ivr_menu_entry.ivr_menu=ivr_menu
    ivr_menu_entry.save
    callplan_id = ivr_menu.action.callplan.id
    if signed_in?
      redirect_to callplan_path(callplan_id)
    else
      redirect_to demo_callplan_path(callplan_id)
    end
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

