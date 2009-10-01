class UsersController < Clearance::SessionsController
  before_filter :settab
  def settab
    @tab = "signup"
  end
end
