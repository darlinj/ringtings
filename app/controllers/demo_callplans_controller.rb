class DemoCallplansController < ApplicationController
  protect_from_forgery
  before_filter :set_tab

  def show
    @callplan = Callplan.find params["id"].to_i
  end

  def create
    RAILS_DEFAULT_LOGGER.error "params controller #{params.inspect}"
    unless params[:demo_callplan] && params[:demo_callplan]['company_name']
      RAILS_DEFAULT_LOGGER.debug "Bad params. Redirecting back to form"
      flash[:error]="We are sorry but there is a problem with the infomation you provided.  Please try again"
      redirect_to (demo_callplans_url)
      return
    end
    @callplan = Callplan.create! :company_name => params[:demo_callplan]['company_name']
    RAILS_DEFAULT_LOGGER.debug "Trying to assign inbound number"
    InboundNumberManager.allocate_free_number_to_callplan(@callplan)
    RAILS_DEFAULT_LOGGER.debug "assigned inbound number #{@callplan.inbound_number.phone_number}"
    @callplan.action = Action.create! :application_name=>"speak",
      :application_data => "Cepstral|Lawrence-8kHz|Welcome to #{@callplan.company_name}, all our operators are busy right now. Please call back soon"
    @callplan.save!
  rescue Exceptions::OutOfCapacityError
    RAILS_DEFAULT_LOGGER.debug "OUT OF INBOUND NUMBERS!!!"
    flash[:error]="We are sorry but we have temporerily run out of free telephone numbers. We are taking steps to get more so please try again soon."
    redirect_to (demo_callplans_url)
  rescue Exception
    flash[:error]="We are sorry but there has been an unexpected problem. We are working to resolve it. Please try again soon."
    redirect_to (demo_callplans_url)
  end

  def update
    @callplan = Callplan.find(params[:id].to_i)
    unless @callplan
        flash[:error]="We are very sorry but we can't complete this operation.  This should not happen if you are using the website as we expect.  We will look into this problem.  Please try again"
        redirect_to (demo_callplans_url)
        return
    end
    unless params[:demo_callplan] && params[:demo_callplan]['phone_number'] && params[:demo_callplan]['email_address']
      return
    end
    Employee.create! :phone_number=> params[:demo_callplan]['phone_number'],
      :email_address => params[:demo_callplan]['email_address'],
      :callplan_id => params[:id].to_i
    @callplan.action.application_name = "ivr"
    @callplan.action.application_data = "ivr_menu_#{@callplan.inbound_number.phone_number}"
    @callplan.action.save!
    @callplan.inbound_number.ivr_menu = create_ivr_menu_options @callplan.employee.phone_number, 
      @callplan.inbound_number.phone_number,
      @callplan.company_name
    @callplan.inbound_number.save!
    @callplan.action.ivr_menu = @callplan.inbound_number.ivr_menu
    @callplan.action.save!
  end

  private
  def set_tab
    @tab="tryit"
  end

  def create_ivr_menu_options target_phone_number, inbound_phone_number, company_name
    ivr_menu_1 = IvrMenuEntry.create! :action => 'menu-exit', :digits => "*",:parameters => nil, :prompt => "Exit the menu"
    ivr_menu_2 = IvrMenuEntry.create! :action => 'menu-exec-app', :digits => "1",:parameters => "transfer #{target_phone_number} XML default", :prompt => "Transfer call to:"
    ivr_menu_3 = IvrMenuEntry.create! :action => 'menu-exec-app', :digits => "2", :parameters => 'voicemail default ${domain_name} ${dialed_extension}', :prompt => "Transfer to voicemail:"
    ivr_menu_4 = IvrMenuEntry.create! :action => 'menu-exec-app', :digits => "3", :parameters => "playback ivr/suckingteeth.wav", :prompt => "Synthetic voice says:"
    ivr_menu_5 = IvrMenuEntry.create! :action => 'menu-exec-app', :digits => "4", :parameters => "playback ivr/suckingteeth.wav", :prompt => "Synthetic voice says:"
    ivr_menu_6 = IvrMenuEntry.create! :action => 'menu-exec-app', :digits => "5", :parameters => "playback ivr/suckingteeth.wav", :prompt => "Synthetic voice says:"
    ivr_menus = [ ivr_menu_1, ivr_menu_2, ivr_menu_3, ivr_menu_4, ivr_menu_5, ivr_menu_6 ]
    long_greeting = "say:Welcome to #{company_name}. please press one to be connected to one of our agents. press two to be connected to leave a message. press three to hear sucking of teeth. four is for an auto quote and 5 is if you want to pay your bill by credit card"
    IvrMenu.create! :name => "ivr_menu_#{inbound_phone_number}", :long_greeting => long_greeting, :ivr_menu_entries => ivr_menus
  end
end
