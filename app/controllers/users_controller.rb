class UsersController < Clearance::SessionsController
  before_filter :settab
  protect_from_forgery
  def settab
    @tab = "signup"
  end
end
