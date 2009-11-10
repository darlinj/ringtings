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
    @callplan = Callplan.create! :company_name => params[:demo_callplan]['company_name']
    @callplan.inbound_number = InboundNumberManager.get_free_number()
    @callplan.action = Action.create! :application_name=>"speak",
      :application_data => "Cepstral|Lawrence-8kHz|Welcome to #{@callplan.company_name}, all our operators are busy right now. Please call back soon"
    @callplan.save!
  rescue Exceptions::OutOfCapacityError
    flash[:error]="We are sorry but we have temporerily run out of free telephone numbers. We are taking steps to get more so please try again soon."
  rescue Exception
    flash[:error]="We are sorry but there has been an unexpected problem. We are working to resolve it. Please try again soon."
  end

  def update
    Employee.create! :phone_number=> params[:demo_callplan]['phone_number'],
      :email_address => params[:demo_callplan]['email_address'],
      :callplan_id => params[:id]
    @callplan = Callplan.find(params[:id])
    @callplan.action.application_name = "ivr"
    @callplan.action.application_data = "ivr_menu_#{@callplan.inbound_number.phone_number}"
    @callplan.action.save!
  end

  private 
  def set_tab
    @tab="tryit"
  end
end
