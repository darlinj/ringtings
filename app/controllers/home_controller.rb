class HomeController < ApplicationController
  protect_from_forgery

  def index
    @tab = 'home'
    if signed_in? && session[:callplan_id]
      @tab = 'callplan'
      redirect_to callplan_url(session[:callplan_id])
    end
  end
end
