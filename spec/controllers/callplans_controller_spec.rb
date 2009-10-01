require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CallplansController do
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
        response.should render_template('callplans/index')
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
        post :create, :callplans=> {'company_name'=>@company_name}
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
        response.should render_template('callplans/create')
      end

      describe "creating the callplan model" do
        it "should call generate on the callplans model" do
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
    end
  end
end
