class FreeswitchController < ApplicationController
  def callplan
    RAILS_DEFAULT_LOGGER.info "Freeswitch request received with params #{params.inspect}" 
    @inbound_number = params['Caller-Destination-Number']
    inbound_number = InboundNumberManager.find_by_phone_number(@inbound_number)
    RAILS_DEFAULT_LOGGER.info "No matching inbound number found" unless inbound_number
    RAILS_DEFAULT_LOGGER.info "No matching callplan found" unless inbound_number && inbound_number.callplan
    if inbound_number && inbound_number.callplan
      RAILS_DEFAULT_LOGGER.info "Inbound number located #{inbound_number.inspect} with callplan #{inbound_number.callplan.inspect}"
      @callplan = inbound_number.callplan
      render :action => 'callplan.xml.builder', :layout => false
    else
      render :action => 'not_found.xml.builder', :layout => false
    end
  end

  def ivr_menus
    inbound_number = InboundNumberManager.find_by_phone_number(inbound_number = params['Caller-Destination-Number'])
    if inbound_number && inbound_number.ivr_menu
      @ivr_menu = inbound_number.ivr_menu
      render :action => 'ivr_menus.xml.builder', :layout => false
    else
      render :action => 'not_found.xml.builder', :layout => false
    end
  end

  def directory
    @inbound_number = params['user']
    @inbound_number_manager = InboundNumberManager.find_by_phone_number(@inbound_number)
    if @inbound_number_manager
      render :action => 'directory.xml.builder', :layout => false
    else
      render :action => 'not_found.xml.builder', :layout => false
    end
  end
end
