class DemoCallplansController < ApplicationController
  protect_from_forgery
  before_filter :set_tab

  def index
    if session[:next_stage] && session[:next_stage].to_i > 1
      redirect_to(demo_callplan_url(session[:callplan_id]))
      return
    end
    session[:next_stage] = "1"
  end

  def show
    @callplan = Callplan.find params["id"].to_i
  end

  def create
    if Callplan.exists?(session[:callplan_id])
      redirect_to demo_callplan_path(session[:callplan_id]) 
      return
    end
    RAILS_DEFAULT_LOGGER.error "params controller #{params.inspect}"
    unless params[:demo_callplan] && params[:demo_callplan]['company_name'] && params[:demo_callplan]['phone_number']
      RAILS_DEFAULT_LOGGER.debug "Bad params. Redirecting back to form"
      flash[:error]="We are sorry but there is a problem with the infomation you provided.  Please try again"
      redirect_to (demo_callplans_url)
      return
    end
    @callplan = Callplan.create! :company_name => params[:demo_callplan]['company_name']
    InboundNumberManager.allocate_free_number_to_callplan(@callplan)

    Employee.create! :phone_number=> params[:demo_callplan]['phone_number'],
      :callplan => @callplan
    @callplan.action = Action.create! :application_name => "ivr",
      :application_data => "ivr_menu_#{@callplan.inbound_number.phone_number}"
    @callplan.inbound_number.ivr_menu = create_ivr_menu_options @callplan.employee.phone_number,
      @callplan.inbound_number.phone_number,
      @callplan.company_name
    @callplan.action.ivr_menu = @callplan.inbound_number.ivr_menu
    @callplan.save!
    session[:next_stage] = "4"
    session[:callplan_id] = @callplan.id
    redirect_to demo_callplan_path(@callplan.id)
  rescue Exceptions::OutOfCapacityError
    RAILS_DEFAULT_LOGGER.debug "OUT OF INBOUND NUMBERS!!!"
    flash[:error]="We are sorry but we have temporerily run out of free telephone numbers. We are taking steps to get more so please try again soon."
    redirect_to (demo_callplans_url)
  end

  def update
    @callplan = Callplan.find(params[:id].to_i)
    unless @callplan
      flash[:error]="We are very sorry but we can't complete this operation.  This should not happen if you are using the website as we expect.  We will look into this problem.  Please try again"
      redirect_to (demo_callplans_url)
      return
    end
    if @callplan.update_attributes(params[:callplan])
      flash[:notice] = "Callplan sucessfully saved"
    else
      flash[:notice] = "Callplan failed to save"
    end
    redirect_to demo_callplan_path(params[:id])
  end

  def create_user
    @user = User.new params[:demo_callplan]
    @user.save!
    @callplan = Callplan.find(params[:id].to_i)
    if @callplan
      @callplan.user_id = @user.id
      @callplan.save!
    end
    ClearanceMailer.deliver_confirmation @user
    flash[:notice] = "You will receive an email within the next few minutes. It contains instructions for confirming your account."
    session[:next_stage] = "5"
    redirect_to demo_callplan_path(params[:id])
  end

  private
  def set_tab
    @tab="tryit"
  end

  def create_ivr_menu_options target_phone_number, inbound_phone_number, company_name
    ivr_menu_1 = MenuExitMenuEntry.create! :digits => "*", :param_1 => nil, :prototype => IvrMenuEntryPrototype.find_by_name("MenuExitMenuEntry")
    ivr_menu_2 = TransferCallMenuEntry.create! :digits => "1", :param_1 => "#{target_phone_number}", :prototype => IvrMenuEntryPrototype.find_by_name("TransferCallMenuEntry")
    ivr_menu_3 = VoiceMailMenuEntry.create! :digits => "2", :param_1 => nil, :prototype => IvrMenuEntryPrototype.find_by_name("VoiceMailMenuEntry")
    ivr_menu_4 = PlayAudioFileMenuEntry.create! :digits => "3", :param_1 => "ivr/suckingteeth.wav", :prototype => IvrMenuEntryPrototype.find_by_name("PlayAudioFileMenuEntry")
    ivr_menu_5 = PlayAudioFileMenuEntry.create! :digits => "4", :param_1 => "ivr/suckingteeth.wav", :prototype => IvrMenuEntryPrototype.find_by_name("PlayAudioFileMenuEntry")
    ivr_menu_6 = PlayAudioFileMenuEntry.create! :digits => "5", :param_1 => "ivr/suckingteeth.wav", :prototype => IvrMenuEntryPrototype.find_by_name("PlayAudioFileMenuEntry")
    ivr_menus = [ ivr_menu_1, ivr_menu_2, ivr_menu_3, ivr_menu_4, ivr_menu_5, ivr_menu_6 ]
    long_greeting = "say:Welcome to #{company_name}. please press one to be connected to one of our agents. press two to be connected to leave a message. press three to hear sucking of teeth. four is for an auto quote and 5 is if you want to pay your bill by credit card"
    IvrMenu.create! :name => "ivr_menu_#{inbound_phone_number}", :long_greeting => long_greeting, :ivr_menu_entries => ivr_menus
  end
end
