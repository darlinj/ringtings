class DemoCallplansController < ApplicationController
  protect_from_forgery
  before_filter :set_tab
  
  def create
    RAILS_DEFAULT_LOGGER.error "params controller #{params.inspect}" 
    unless params[:demo_callplan] && params[:demo_callplan]['company_name']
        flash[:error]="We are sorry but there is a problem with the infomation you provided.  Please try again"
        redirect_to (demo_callplans_url)
        return
    end
    callplan = Callplan.create! :company_name => params[:demo_callplan]['company_name']
    callplan.inbound_number = InboundNumberManager.get_free_number()
    callplan.save!
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
