class IvrMenuEntryController < ApplicationController
  def destroy
    IvrMenuEntry.destroy params[:id].to_i
    redirect_to :back 
  end
end

