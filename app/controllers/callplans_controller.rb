class CallplansController < ApplicationController

  def show
    @callplan = Callplan.find(params[:id].to_i)
  end
end
