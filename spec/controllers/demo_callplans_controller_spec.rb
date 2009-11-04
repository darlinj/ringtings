require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DemoCallplansController do
  describe "the call plans resource" do
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
        @inbound_number = mock_model(InboundNumberManager,:phone_number => "0987654321")
        @parameters = {:company_name=>@company_name}
        @callplan = mock_model(Callplan, :company_name=>@company_name, :inbound_number=>@inbound_number)
        Callplan.stub(:generate).and_return(@callplan)
      end

      def do_post 
        post :create, :demo_callplans => {'company_name'=>@company_name}
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
        it "should call generate on the demo_callplans model" do
          Callplan.should_receive(:generate).with('company_name'=>@company_name)
          do_post
        end

        it "should assign the tab variable" do
          do_post 
          assigns[:tab].should == @tab
        end

        it "should assign the company name" do
          do_post 
          assigns[:company_name].should == @company_name
        end

        it "should assign the inbound number variable" do
          do_post 
          assigns[:inbound_number].should == @inbound_number.phone_number
        end
      end
      describe "what happens if there is a problem with callplan creation" do
        describe "when there are no more numbers available for allocation" do
          before do
            Callplan.stub(:generate).and_raise(Exceptions::OutOfCapacityError)
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
            Callplan.stub(:generate).and_raise(StandardError)
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
    end
  end
end
