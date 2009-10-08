class FreeswitchController < ApplicationController
  def create
    RAILS_DEFAULT_LOGGER.info "Freeswitch request received with params #{params.inspect}" 
    @inbound_number = params['Caller-Destination-Number']
    inbound_number = InboundNumberManager.find_by_phone_number(@inbound_number)
    RAILS_DEFAULT_LOGGER.info "No matching inbound number found" unless inbound_number
    RAILS_DEFAULT_LOGGER.info "No matching callplan found" unless inbound_number && inbound_number.callplan
    if inbound_number && inbound_number.callplan
      RAILS_DEFAULT_LOGGER.info "Inbound number located #{inbound_number.inspect} with callplan #{inbound_number.callplan.inspect}"
      @say_phrase = "Welcome to #{inbound_number.callplan.company_name}, all our operators are busy right now. Please leave a message after the tone"
      render :action => 'create.xml.builder', :layout => false
    else
      render :text => '', :layout => false
    end
  end
end
