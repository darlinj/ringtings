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
        @action = mock_model Action, :application_name=>"SomeRandomApplication" , :application_data=>"Dummy Data"
        @inbound_number = mock_model InboundNumberManager, :phone_number=>@phone_number
        @employee = mock_model Employee, :phone_number => @employee_phone_number,:email_address => @email_address
        Employee.stub(:create!).and_return @employee
        @callplan = mock_model Callplan, :company_name => @company_name, :action=>@action, :inbound_number => @inbound_number, :employee => @employee
        Callplan.stub(:find).and_return @callplan
        @action.stub(:application_name=)
        @action.stub(:application_data=)
        @action.stub(:save!)
        @params1 = {:action => 'menu-exit', :digits => "*",:parameters => nil}
        @params2 = {:action => 'menu-exec-app', :digits => "1",:parameters => "transfer #{@employee_phone_number} XML default"}
        @params3 = {:action => 'menu-exec-app', :digits => "2", :parameters => 'voicemail default ${domain_name} ${dialed_extension}'}
        @params4 = {:action => 'menu-exec-app', :digits => "3", :parameters => "playback ivr/suckingteeth.wav"}
        @params5 = {:action => 'menu-exec-app', :digits => "4", :parameters => "playback ivr/suckingteeth.wav"}
        @params6 = {:action => 'menu-exec-app', :digits => "5", :parameters => "playback ivr/suckingteeth.wav"}
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
        @inbound_number.stub(:save!)
      end

      def do_put
        put :update, :id => @callplan.id, :demo_callplan => {'company_name'=>@company_name, 'phone_number' => @employee_phone_number, 'email_address' => @email_address }
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
          @attributes = {:phone_number=> @employee_phone_number, :email_address => @email_address, :callplan_id => @callplan.id}
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

      describe "connecting the inbound number with the callplan" do
        it "should assign the ivr_menu to the inbound number" do
          @inbound_number.should_receive(:ivr_menu=).with(@ivr_menu)
          do_put
        end
        it "will save the ivr_menu" do
          @inbound_number.should_receive(:save!)
          do_put
        end
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
  end
end
