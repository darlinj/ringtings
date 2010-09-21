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
  rescue ActiveRecord::RecordNotFound
    session[:callplan_id] = nil
    session[:next_stage] = 1
    redirect_to demo_callplans_path
  end

  def create
    if Callplan.exists?(session[:callplan_id])
      redirect_to demo_callplan_path(session[:callplan_id])
      return
    end
    @callplan = Callplan.create_demo params[:demo_callplan]['phone_number'],
      params[:demo_callplan]['company_name']
    session[:next_stage] = "4"
    session[:callplan_id] = @callplan.id
    redirect_to demo_callplan_path(@callplan.id)
  rescue Exceptions::OutOfCapacityError
    RAILS_DEFAULT_LOGGER.debug "OUT OF INBOUND NUMBERS!!!"
    flash[:error]="We are sorry but we have temporerily run out of free telephone numbers. We are taking steps to get more so please try again soon."
    redirect_to root_url
  rescue Exception
    flash[:error]="We are sorry but there is a problem with the infomation you provided.  Please try again"
    redirect_to root_url
  end

  def update
    callplan = Callplan.find(params[:id].to_i)
    unless callplan
      flash[:error]="We are very sorry but we can't complete this operation.  This should not happen if you are using the website as we expect.  We will look into this problem.  Please try again"
      redirect_to demo_callplans_url
      return
    end
    if callplan.update_attributes(params[:callplan])
      flash[:notice] = "Callplan sucessfully saved"
    else
      flash[:notice] = "Callplan failed to save"
    end
    @callplan = callplan
    respond_to do |format|
      format.html { render :template =>"demo_callplans/show" }
      format.js {render :layout =>false}
    end
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
    render :template =>"demo_callplans/show"
  end

  private
  def set_tab
    @tab="tryit"
  end
end
