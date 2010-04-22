class IvrMenuEntriesController < ApplicationController
  def create
    ivr_menu_entry_prototype = IvrMenuEntryPrototype.find_by_name(params['type'])
    ivr_menu_entry = Module.const_get(params['type']).new :digits => "1",
      :param_1 => ivr_menu_entry_prototype.param_1_default,
      :prototype => ivr_menu_entry_prototype
    ivr_menu = IvrMenu.find(params['ivr_menu_id'].to_i)
    if ivr_menu.ivr_menu_entries
      ivr_menu_entry.digits = (ivr_menu.ivr_menu_entries.map {|e| e.digits}.max.to_i+1).to_s
    end
    ivr_menu_entry.ivr_menu=ivr_menu
    ivr_menu_entry.save
    redirect_to_callplan(ivr_menu_entry)
  end

  def destroy
    ivr_menu_entry = IvrMenuEntry.find(params[:id].to_i)
    IvrMenuEntry.destroy params[:id].to_i
    redirect_to_callplan(ivr_menu_entry)
  end
end

