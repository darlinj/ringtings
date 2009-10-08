class SessionsController < Clearance::SessionsController
  protect_from_forgery
  private
  def url_after_destroy
    root_path
  end
end
