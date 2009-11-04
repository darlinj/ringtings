require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FreeswitchController do
  describe "getting a callplan request" do
    describe "when there is a callplan with an associated phone number in the database" do
      before do
        InboundNumberManager.destroy_all
        @inbound_number = "0123456789"
        @company_name = "fettle and watkins"
        @callplan = Factory :callplan, :company_name => @company_name
        @inbound_number_manager = Factory :inbound_number_manager, :phone_number => @inbound_number, :callplan_id => @callplan.id
      end
      def do_post 
        post :callplan, 'Caller-Destination-Number'=>@inbound_number
      end
      it "should respond to post requests" do
        do_post.should be_success
      end
      it "should render the xml dial plan template" do
        do_post.should render_template('callplan.xml.builder')
      end
      it "will look up the call plan associated with the inbound number supplied" do
        InboundNumberManager.should_receive(:find_by_phone_number).with(@inbound_number).and_return(@inbound_number_manager)
        do_post
      end
      it "will assign the appropriate callplan" do
        do_post
        assigns[:callplan].should == @callplan
      end
      it "will assign the inbound number for the view" do
        do_post
        assigns[:inbound_number].should == @inbound_number
      end
    end
    describe "When there is no matching phone number in the database" do
      before do
        @inbound_number = "0123456789"
        InboundNumberManager.destroy_all
      end
      def do_post 
        post :callplan, 'Caller-Destination-Number'=>@inbound_number
      end
      it 'should return an empty body' do
        do_post.should render_template('not_found.xml.builder')
      end
    end
    describe "When there is a matching phone number in the database but no callplan" do
      before do
        @inbound_number = "0123456789"
        InboundNumberManager.destroy_all
        Factory :inbound_number_manager, :phone_number => @inbound_number, :callplan_id => nil
      end
      def do_post 
        post :callplan, 'Caller-Destination-Number'=>@inbound_number
      end
      it 'should return an empty body' do
        do_post.should render_template('not_found.xml.builder')
      end
    end
  end

  describe "getting a post to ivr_menus request" do
    before do
      @inbound_number = "0123456789"
      @company_name = "Bob Basted used cars"
      @callplan = Factory :callplan, :company_name => @company_name
      @inbound_number_manager = Factory :inbound_number_manager, :phone_number => @inbound_number, :callplan_id => @callplan.id
    end
    def do_ivr_post 
      post :ivr_menus, 'Caller-Destination-Number'=>@inbound_number
    end
    it "should respond to post requests" do
      do_ivr_post.should be_success
    end
    it "should render the xml ivr_menus template" do
      do_ivr_post.should render_template('ivr_menus.xml.builder')
    end

    describe "When there is no matching phone number in the database" do
      before do
        InboundNumberManager.destroy_all
      end
      it 'renders the not found response' do
        do_ivr_post.should render_template('not_found.xml.builder')
      end
    end
  end
end
