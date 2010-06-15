require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do
  def do_get 
    get :index
  end

  it "should set the tab" do
    do_get 
    assigns[:tab].should == "home"
  end

  context "if the user is logged in" do
    before do
      controller.stub(:signed_in?).and_return true
      @callplan_id = 1
      session[:callplan_id] = @callplan_id
    end

    it "should set the tab" do
      do_get 
      assigns[:tab].should == "callplan"
    end

    it "should redirect to the callplan page" do
      do_get 
      controller.should redirect_to callplan_url(@callplan_id)
    end
  end
end
