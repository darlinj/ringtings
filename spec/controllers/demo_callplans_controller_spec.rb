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

      it "should set the session next stage to 1" do
        do_get
        session[:next_stage].should == "1"
      end

      describe "accessing the index page if the stage is not set to nil or 0" do
        it "should redirect to the callplan page" do
          session[:next_stage] = 2
          @callplan_id = 99
          session[:callplan_id] = @callplan_id
          do_get
          response.should redirect_to(demo_callplan_url(@callplan_id))
        end
      end
    end

    describe "the creation of a call plan" do
      before do
        @company_name = "foobar inc"
        @employee_phone_number = "09876543210"
        @phone_number = "0123456789"
        @callplan = mock_model Callplan, :company_name => @company_name
        Callplan.stub(:create_demo).and_return @callplan
        Callplan.stub(:exists?).and_return false
      end

      def do_post
        post :create, :demo_callplan => {'company_name'=>@company_name, 'phone_number' => @employee_phone_number}
      end

      it "should assign the tab variable" do
        do_post
        assigns[:tab].should == @tab
      end

      it "renders the generate template" do
        do_post
        response.should redirect_to(demo_callplan_url(@callplan.id))
      end

      describe "when the session id is set" do
        before do
          session[:callplan_id] = @callplan.id
          Callplan.stub(:exists?).and_return @callplan
        end

        it "will redirect to the existing callplan" do
          do_post
          response.should redirect_to(demo_callplan_url(@callplan.id))
        end

        it "will not call create" do
          Callplan.should_not_receive(:create!)
          do_post
        end
      end

      describe "creating the callplan model" do
        it "has a callplan " do
          do_post
          assigns[:callplan].should == @callplan
        end

        it "should set the session next stage to 4" do
          do_post
          session[:next_stage].should == "4"
        end

        it "should set the session callplan_id" do
          do_post
          session[:callplan_id].should == @callplan.id
        end

        it "should send an email to the admin" do
          NotificationMailer.should_receive(:deliver_trying_it)
          do_post
        end
      end

      describe "what happens if there is a problem with inbound number creation" do
        describe "when there are no more numbers available for allocation" do
          before do
            Callplan.stub(:create_demo).and_raise(Exceptions::OutOfCapacityError)
          end
          it "catches all errors" do
            lambda {do_post}.should_not raise_error
          end
          it "creates a flash message" do
            do_post
            flash[:error].should == "We are sorry but we have temporerily run out of free telephone numbers. We are taking steps to get more so please try again soon."
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

      describe "the telephone not being the correct length" do
        it "sets the flash correctly and redirects back to the form" do
          @employee_phone_number = "rubbish"
          post :create
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
        @action = mock_model Action, :application_name=>"SomeRandomApplication" , :application_data=>"Dummy Data"
        @inbound_number = mock_model InboundNumberManager, :phone_number=>@phone_number
        @employee = mock_model Employee, :phone_number => @employee_phone_number,:email_address => @email_address
        Employee.stub(:create!).and_return @employee
        @callplan = mock_model Callplan, :company_name => @company_name, :action=>@action, :inbound_number => @inbound_number, :employee => @employee
        Callplan.stub(:find).and_return @callplan
        @callplan.stub(:save)
        @callplan.stub(:save!)
        @callplan.stub(:user_id=)
      end

      describe "when the email,password and password confirmation are set" do
        before do
          @callplan = mock_model Callplan
          Callplan.stub(:find).and_return @callplan
          @email_address = "freddy@rock.com"
          @password = "secret"
          @user = mock_model User
          User.stub(:new).and_return @user
          @user.stub(:save!)
          ClearanceMailer.stub(:deliver_confirmation)
          @callplan.stub(:user_id=)
          @callplan.stub(:save!)
        end

        def do_post
          put :create_user, :id => @callplan.id,
            :demo_callplan => {'email' => @email_address,
              'password' => @password,
              'password_confirmed' => @password}
        end

        it "creates a user" do
          @expected_params = {'email' => @email_address, 'password' =>@password, 'password_confirmed' =>@password}
          User.should_receive(:new).with(@expected_params)
          do_post
        end

        it "saves the user" do
          @user.should_receive(:save!)
          do_post
        end

        it "looks up the callplan" do
          Callplan.should_receive(:find).with(@callplan.id)
          do_post
        end

        describe "when there is a callplan" do
          it "assigns the user id to the callplan" do
            @callplan.should_receive(:user_id=).with(@user.id)
            do_post
          end

          it "saves the callplan" do
            @callplan.should_receive(:save!)
            do_post
          end
        end


        it "send a confirmation email" do
          ClearanceMailer.should_receive(:deliver_confirmation).with @user
          do_post
        end

        it "creates a flash message" do
          do_post
          flash[:notice].should == "You will receive an email within the next few minutes. It contains instructions for confirming your account."
        end

        it "should set the session next stage to 5" do
          do_post
          session[:next_stage].should == "5"
        end

        it "redirects to the show page" do
          do_post
          response.should redirect_to(demo_callplan_url(@callplan.id))
        end
      end
    end
    describe "the show of a demo call plan" do
      before do
        @callplan = mock_model Callplan
        Callplan.stub(:find).and_return @callplan
      end
      def do_get
        get :show, :id => @callplan.id
      end

      it "responds to put" do
        do_get
        response.should be_success
      end

      it "should assign the tab variable" do
        do_get
        assigns[:tab].should == @tab
      end

      it "renders the generate template" do
        do_get
        response.should render_template('demo_callplans/show')
      end

      it 'will get a call to find the callplan' do
        Callplan.should_receive(:find).with(@callplan.id)
        do_get
      end

      it "assigns @callplan" do
        do_get
        assigns[:callplan].should == @callplan
      end

      describe "when the callplan doesn't exist" do
        it "should redirect to the try it now page" do
          Callplan.stub(:find).and_raise ActiveRecord::RecordNotFound
          do_get
          response.should redirect_to demo_callplans_path
        end
      end
    end

    describe "saving the callplan" do
      before do
        @callplan = mock_model Callplan
        Callplan.stub(:find).and_return @callplan
        @callplan.stub(:update_attributes).and_return true
      end
      def do_put 
        put :update, :id => @callplan.id, :callplan => @callplan
      end
      it "finds the right callplan" do
        Callplan.should_receive(:find).with(@callplan.id)
        do_put
      end
      it "saves the callplan" do
        @callplan.should_receive(:update_attributes).with @callplan
        do_put
      end
      describe "sucessfully" do
        it "should set the flash to apropriate text" do
          do_put
          flash[:notice].should == "Callplan sucessfully saved"
        end
      end
      describe "UN-sucessfully" do
        before do
          @callplan.stub(:update_attributes).and_return false
        end
        it "should set the flash to apropriate text" do
          do_put
          flash[:notice].should == "Callplan failed to save"
        end
      end
      it "should redirect to the callpln show page" do
        do_put
        response.should redirect_to(demo_callplan_url(@callplan.id))
      end
    end

  end
end
