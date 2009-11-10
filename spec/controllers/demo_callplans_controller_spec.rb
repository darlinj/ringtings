require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DemoCallplansController do
  describe "the demo call plans resource" do
    before do
      @tab="tryit"
    end
    describe "the index page" do
      def do_get 
        get :index
      end
      it "responds to index" do
        do_get
        response.should be_success
      end
      it "renders the index template" do
        do_get 
        response.should render_template('demo_callplans/index')
      end

    end
    describe "the creation of a call plan" do
      before do
        @company_name = "foobar inc"
        @phone_number = "0123456789"
        InboundNumberManager.destroy_all
        Callplan.destroy_all
        Factory :inbound_number_manager, :phone_number=>@phone_number , :callplan_id=>nil
      end

      def do_post 
        post :create, :demo_callplan => {'company_name'=>@company_name}
      end

      it "responds to create" do
        do_post
        response.should be_success
      end

      it "should assign the tab variable" do
        do_post 
        assigns[:tab].should == @tab
      end

      it "renders the generate template" do
        do_post 
        response.should render_template('demo_callplans/create')
      end

      describe "creating the callplan model" do
        it "should assign the tab variable" do
          do_post 
          assigns[:tab].should == @tab
        end

        it "has a callplan " do
          do_post
          assigns[:callplan].should_not be_nil
        end

        it "has a callplan with the correct company name" do
          do_post
          assigns[:callplan].company_name.should == @company_name
        end

        it "has a callplan with the correct inbound_number name" do
          do_post
          assigns[:callplan].inbound_number.phone_number.should == @phone_number
        end

        describe "creating the action attached to the callplan" do
          it "will be an action attached to the callplan" do
            do_post
            Callplan.find_by_company_name(@company_name).action.should_not be_nil
          end
          it "will have an application_name attribute" do
            do_post
            Callplan.find_by_company_name(@company_name).action.application_name.should == "speak"
          end
          it "will have an application_data attribute" do
            do_post
            Callplan.find_by_company_name(@company_name).action.application_data.should == "Cepstral|Lawrence-8kHz|Welcome to #{@company_name}, all our operators are busy right now. Please call back soon"
          end
        end
      end
      describe "what happens if there is a problem with inbound number creation" do
        describe "when there are no more numbers available for allocation" do
          before do
            InboundNumberManager.stub(:get_free_number).and_raise(Exceptions::OutOfCapacityError)
          end
          it "catches all errors" do
            lambda {do_post}.should_not raise_error
          end
          it "creates a flash message" do
            do_post
            flash[:error].should == "We are sorry but we have temporerily run out of free telephone numbers. We are taking steps to get more so please try again soon."
          end
        end
        describe "when there is an unexpected error" do
          before do
            Callplan.stub(:create!).and_raise(StandardError)
          end
          it "catches all errors" do
            lambda {do_post}.should_not raise_error
          end
          it "creates a flash message" do
            do_post
            flash[:error].should == "We are sorry but there has been an unexpected problem. We are working to resolve it. Please try again soon."
          end
        end
 
      end
      describe "the parameters not being in the request" do
        it "doesn't have a demo_callplan hash" do
          post :create
          flash[:error].should == "We are sorry but there is a problem with the infomation you provided.  Please try again"
          response.should redirect_to(demo_callplans_url)
        end
        it "doesn't have a company name in the demo_callplans hash" do
          post :create, :demo_callplan => {'foo'=>"bar"}
          flash[:error].should == "We are sorry but there is a problem with the infomation you provided.  Please try again"
          response.should redirect_to(demo_callplans_url)
        end 
      end
    end

    describe "the update of a demo call plan" do
      before do
        @company_name = "foobar inc"
        @phone_number = "0123456789"
        @email_address = "bob.basted@used.cars.net"
        @employee_phone_number = "0987654321"
        InboundNumberManager.destroy_all
        Callplan.destroy_all
        @callplan = Factory :callplan, :company_name => @company_name 
        Factory :inbound_number_manager, :phone_number=>@phone_number , :callplan_id=>@callplan.id
        Factory :action, :application_name=>"SomeRandomApplication" , :application_data=>"Dummy Data", :callplan_id=>@callplan.id
      end

      def do_put 
        put :update, :id => @callplan.id, :demo_callplan => {'company_name'=>@company_name, 'employee_phone_number' => @employee_phone_number, 'email_address' => @email_address }
      end

      it "responds to put" do
        do_put
        response.should be_success
      end

      it "should assign the tab variable" do
        do_put 
        assigns[:tab].should == @tab
      end

      it "renders the generate template" do
        do_put 
        response.should render_template('demo_callplans/update')
      end

      it "assigns @callplan" do
        do_put 
        assigns[:callplan].should_not be_nil
      end

      it "has a callplan with the correct inbound number" do
        do_put
        assigns[:callplan].inbound_number.phone_number.should == @phone_number
      end

      it "has a callplan with the correct company name" do
        do_put
        assigns[:callplan].company_name.should == @company_name
      end

      it "has a callplan with the correct email address" do
        do_put
        assigns[:callplan].employee.email_address.should == @email_address
      end
      it "has a callplan with the correct user phone number" do
        do_put
        assigns[:callplan].employee.phone_number.should == @employee_phone_number
      end

      it "will change the Callplan to point to the ivr application" do
        do_put
        Callplan.find(@callplan.id).action.application_name.should == "ivr"
      end
      it "will change the Callplan data to send the callplan id" do
        do_put
        Callplan.find(@callplan.id).action.application_data.should == "ivr_menu_#{@phone_number}"
      end
    end
  end
end
