class CallplansController < ApplicationController
  before_filter :set_tab
  
  def create
    RAILS_DEFAULT_LOGGER.error "params controller #{params.inspect}" 
    callplan = Callplan.generate params[:callplans]
    @company_name = callplan.company_name
    @inbound_number = callplan.inbound_number.phone_number
  rescue Exceptions::OutOfCapacityError
    flash[:error]="We are sorry but we have temporerily run out of free telephone numbers. We are taking steps to get more so please try again soon."
  rescue Exception
    flash[:error]="We are sorry but there has been an unexpected problem. We are working to resolve it. Please try again soon."
  end

  private 
  def set_tab
    @tab="tryit"
  end
end
