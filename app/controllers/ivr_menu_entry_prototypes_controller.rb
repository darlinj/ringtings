class IvrMenuEntryPrototypesController < ApplicationController
  def index
    @ivr_menu_entry_prototypes = IvrMenuEntryPrototype.all
    @ivr_menu_id = params['ivr_menu_id']
    respond_to do |format|
      format.html { render :template =>"ivr_menu_entry_prototypes/index", :layout => false }
      format.js { render :template =>"ivr_menu_entry_prototypes/index.js", :layout => false }
    end
  end
end

