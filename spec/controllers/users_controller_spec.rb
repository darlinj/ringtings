require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  describe "creating a user" do
    def do_post
      post :create, {"commit"=>"Sign up", "action"=>"create", "authenticity_token"=>"9lFiLbHbkw6QssCqux+pBifbNAtcG8IuQ2PNBYjKwaI=", "controller"=>"users", "user"=>{"password_confirmation"=>"pass", "password"=>"pass", "email"=>"foo@bar.com"}}
    end

    it "assigns the tab" do
      do_post
      assigns[:tab].should == "signup"
    end

    describe "when the http referrer is the demo callplans page" do
      before do
        @demo_callplan_url = "http://ringtings.com/demo_callplans/1"
        request.env["HTTP_REFERER"] = @demo_callplan_url
      end

      it "should redirect back tothe demo callplans page" do
        do_post.should redirect_to @demo_callplan_url
      end
    end

    describe "when the http referrer is NOT the demo callplans page" do
      before do
        @demo_callplan_url = "http://ringtings.com/anything_else"
        request.env["HTTP_REFERER"] = @demo_callplan_url
      end

      def do_post
        post :create, {"commit"=>"Sign up", "action"=>"create", "authenticity_token"=>"9lFiLbHbkw6QssCqux+pBifbNAtcG8IuQ2PNBYjKwaI=", "controller"=>"users", "user"=>{"password_confirmation"=>"pass", "password"=>"pass", "email"=>"foo@bar.com"}}
      end

      it "should redirect back tothe demo callplans page" do
        do_post.should_not redirect_to @demo_callplan_url
      end
    end
  end
end
