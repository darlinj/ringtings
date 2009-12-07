class CallplansController < ApplicationController
  before_filter :authenticate
  before_filter :set_tab

  def show
    @callplan = Callplan.find(params[:id].to_i)
  end

  private
  def set_tab
    @tab="callplan"
  end
end
