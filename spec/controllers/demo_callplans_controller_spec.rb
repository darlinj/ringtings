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
        @phone_number = "0123456789"
        @action = mock_model Action
        @callplan = mock_model Callplan, :company_name => @company_name
        @inbound_number = mock_model InboundNumberManager, :phone_number => "475375"
        Action.stub(:create!).and_return @action
        Callplan.stub(:create!).and_return @callplan
        @callplan.stub(:inbound_number).and_return @inbound_number
        @callplan.stub(:action=)
        @callplan.stub(:save!)
        InboundNumberManager.stub(:allocate_free_number_to_callplan)
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
          InboundNumberManager.should_receive(:allocate_free_number_to_callplan).with(@callplan)
          do_post
        end

        describe "creating the action attached to the callplan" do
          it "will be an action attached to the callplan" do
            @callplan.should_receive(:action=).with @action
            do_post
          end

          it "will create the action with the right params" do
            Action.should_receive(:create!).with(:application_name => "speak",
                                                 :application_data => "Cepstral|Lawrence-8kHz|Welcome to #{@company_name}, all our operators are busy right now. Please call back soon" )
            do_post
          end
        end

        it "should set the session next stage to 2" do
          do_post
          session[:next_stage].should == "2"
        end

        it "should set the session callplan_id" do
          do_post
          session[:callplan_id].should == @callplan.id
        end
      end
      describe "what happens if there is a problem with inbound number creation" do
        describe "when there are no more numbers available for allocation" do
          before do
            InboundNumberManager.stub(:allocate_free_number_to_callplan).and_raise(Exceptions::OutOfCapacityError)
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

      describe "when the email and employee number parameters are set" do
        before do
          @action.stub(:application_name=)
          @action.stub(:application_data=)
          @action.stub(:ivr_menu=)
          @action.stub(:save!)
          @params1 = {:action => 'menu-exit', :digits => "*", :system_param_part => nil, :user_param_part => nil, :prompt => "Exit the menu" }
          @params2 = {:action => 'menu-exec-app', :digits => "1", :system_param_part => "transfer", :user_param_part => "#{@employee_phone_number} XML default", :prompt => "Transfer call to:" }
          @params3 = {:action => 'menu-exec-app', :digits => "2", :system_param_part => "voicemail default ${domain_name} ${dialed_extension}", :user_param_part => nil, :prompt => "Transfer to voicemail:" }
          @params4 = {:action => 'menu-exec-app', :digits => "3", :system_param_part => "playback", :user_param_part => "ivr/suckingteeth.wav", :prompt => "Play an audio file:" }
          @params5 = {:action => 'menu-exec-app', :digits => "4", :system_param_part => "playback", :user_param_part => "ivr/suckingteeth.wav", :prompt => "Play an audio file:" }
          @params6 = {:action => 'menu-exec-app', :digits => "5", :system_param_part => "playback", :user_param_part => "ivr/suckingteeth.wav", :prompt => "Play an audio file:" }
          @ivr_menu_entry1 = mock_model IvrMenuEntry, @params1
          @ivr_menu_entry2 = mock_model IvrMenuEntry, @params2
          @ivr_menu_entry3 = mock_model IvrMenuEntry, @params3
          @ivr_menu_entry4 = mock_model IvrMenuEntry, @params4
          @ivr_menu_entry5 = mock_model IvrMenuEntry, @params5
          @ivr_menu_entry6 = mock_model IvrMenuEntry, @params6
          IvrMenuEntry.stub(:create!).and_return @ivr_menu_entry1, @ivr_menu_entry2, @ivr_menu_entry3, @ivr_menu_entry4, @ivr_menu_entry5, @ivr_menu_entry6
          @ivr_menu_entries = [@ivr_menu_entry1, @ivr_menu_entry2, @ivr_menu_entry3, @ivr_menu_entry4, @ivr_menu_entry5, @ivr_menu_entry6]
          @ivr_menu = mock_model IvrMenu
          IvrMenu.stub(:create!).and_return @ivr_menu
          @inbound_number.stub(:ivr_menu=)
          @inbound_number.stub(:ivr_menu).and_return @ivr_menu
          @inbound_number.stub(:save!)
        end

        def do_put
          put :generate_full_demo_callplan, :id => @callplan.id, :demo_callplan => {'company_name'=>@company_name, 'phone_number' => @employee_phone_number, 'email_address' => @email_address }
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
          response.should render_template('demo_callplans/generate_full_demo_callplan')
        end

        it 'will get a call to find the callplan' do
          Callplan.should_receive(:find).with(@callplan.id)
          do_put
        end

        it "assigns @callplan" do
          do_put
          assigns[:callplan].should_not be_nil
        end


        describe "creating the employee" do
          it "creates the employee" do
            @attributes = {:phone_number=> @employee_phone_number, :callplan_id => @callplan.id}
            Employee.should_receive(:create!).with(@attributes)
            do_put
          end
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
          @action.should_receive(:application_name=).with("ivr")
          do_put
        end

        it "will change the Callplan data to send the callplan id" do
          @action.should_receive(:application_data=).with("ivr_menu_#{@phone_number}")
          do_put
        end

        describe "creating the ivr menu entries" do
          it "creates 5 ivr menu entries" do
            IvrMenuEntry.should_receive(:create!).exactly(6).times
            do_put
          end
          it "has an exit option in the first entry" do
            IvrMenuEntry.should_receive(:create!).with(@params1)
            IvrMenuEntry.should_receive(:create!).with(@params2)
            IvrMenuEntry.should_receive(:create!).with(@params3)
            IvrMenuEntry.should_receive(:create!).with(@params4)
            IvrMenuEntry.should_receive(:create!).with(@params5)
            IvrMenuEntry.should_receive(:create!).with(@params6)
            do_put
          end
        end

        it "creates a ivr menu item with the right parameters" do
          long_greeting = "say:Welcome to #{@company_name}. please press one to be connected to one of our agents. press two to be connected to leave a message. press three to hear sucking of teeth. four is for an auto quote and 5 is if you want to pay your bill by credit card"
          params = {:name => "ivr_menu_#{@phone_number}", :long_greeting => long_greeting, :ivr_menu_entries => @ivr_menu_entries }
          IvrMenu.should_receive(:create!).with params
          do_put
        end

        it "should assign the ivr_menu to the inbound number" do
          @action.should_receive(:ivr_menu=).with(@ivr_menu)
          do_put
        end

        describe "connecting the inbound number with the ivr menu" do
          it "should assign the ivr_menu to the inbound number" do
            @inbound_number.should_receive(:ivr_menu=).with(@ivr_menu)
            do_put
          end
        end

        it "should set the session next stage to 4" do
          do_put
          session[:next_stage].should == "4"
        end

        describe "if the callplan can't be found" do
          before do
            Callplan.stub(:find).and_return nil
          end
          it "sets a flash message and returns to the tryit page" do
            do_put
            flash[:error].should == "We are very sorry but we can't complete this operation.  This should not happen if you are using the website as we expect.  We will look into this problem.  Please try again"
            response.should redirect_to(demo_callplans_url)
          end
        end
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

        def do_put
          put :create_user, :id => @callplan.id,
            :demo_callplan => {'email' => @email_address,
              'password' => @password,
              'password_confirmed' => @password}
        end

        it "creates a user" do
          @expected_params = {'email' => @email_address, 'password' =>@password, 'password_confirmed' =>@password}
          User.should_receive(:new).with(@expected_params)
          do_put
        end

        it "saves the user" do
          @user.should_receive(:save!)
          do_put
        end

        it "looks up the callplan" do
          Callplan.should_receive(:find).with(@callplan.id)
          do_put
        end

        describe "when there is a callplan" do
          it "assigns the user id to the callplan" do
            @callplan.should_receive(:user_id=).with(@user.id)
            do_put
          end
          
          it "saves the callplan" do
            @callplan.should_receive(:save!)
            do_put
          end
        end


        it "send a confirmation email" do
          ClearanceMailer.should_receive(:deliver_confirmation).with @user
          do_put
        end

        it "creates a flash message" do
          do_put
          flash[:notice].should == "You will receive an email within the next few minutes. It contains instructions for confirming your account."
        end

        it "should set the session next stage to 5" do
          do_put
          session[:next_stage].should == "5"
        end

        it "redirects to the show page" do
          do_put
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
