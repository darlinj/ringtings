# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Clearance::Authentication
  helper :all # include all helpers, all the time
  layout 'standard'
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include Exceptions

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  #
  def redirect_to_callplan ivr_menu_entry
    callplan_id = ivr_menu_entry.ivr_menu.action.callplan.id
    if signed_in?
      redirect_to callplan_path(callplan_id)
    else
      redirect_to demo_callplan_path(callplan_id)
    end
  end
end
