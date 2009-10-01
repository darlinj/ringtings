class CallplansController < ApplicationController
  before_filter :set_tab
  
  def create
    RAILS_DEFAULT_LOGGER.error "params controller #{params.inspect}" 
    callplan = Callplan.generate params[:callplans]
    RAILS_DEFAULT_LOGGER.error "callplan #{callplan.inspect}" 
    @company_name = callplan.company_name
    @inbound_number = callplan.inbound_number.phone_number
  end
  private 
  def set_tab
    @tab="tryit"
  end
end
