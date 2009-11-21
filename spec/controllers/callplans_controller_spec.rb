require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CallplansController do
  describe "the demo call plans resource" do
    before do
      @tab="callplans"
      @callplan = mock_model Callplan
      @callplan_id =  @callplan.id
      Callplan.stub(:find).and_return @callplan
    end
    describe "the show" do
      def do_get
        get :show, :id => @callplan_id
      end
      it "responds to show" do
        do_get
        response.should be_success
      end
      it "renders the index template" do
        do_get
        response.should render_template('callplans/show')
      end
      it "finds the callplan based on the id" do
        Callplan.should_receive(:find).with(@callplan_id).and_return @callplan
        do_get
      end
      it "sets the callplan instance variable" do
        do_get
        assigns[:callplan].should == @callplan
      end
    end
  end
end
