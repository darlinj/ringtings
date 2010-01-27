class IvrMenuEntryPrototypesController < ApplicationController
  def index
    @ivr_menu_entry_prototypes = IvrMenuEntryPrototype.all
    @ivr_menu_id = params['ivr_menu_id']
  end
end

