class HomeController < ApplicationController
  protect_from_forgery

  def index
    @tab = 'home'
  end

end
