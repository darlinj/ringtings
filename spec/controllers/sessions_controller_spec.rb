require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do
  describe ".destroy" do
    it "should redirect to the right place" do
      delete :destroy, :method=>:delete
      response.should redirect_to root_path
    end
  end
end
