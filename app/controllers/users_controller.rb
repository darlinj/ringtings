class UsersController < Clearance::UsersController
  before_filter :settab
  protect_from_forgery
  def settab
    @tab = "signup"
  end

  private
  def url_after_create
    if request.headers["HTTP_REFERER"] =~ /demo_callplans/
      request.headers["HTTP_REFERER"]
    else
      super
    end
  end
end
