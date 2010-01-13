require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CallplansController do
  describe "the demo call plans resource" do
    before do
      @user = Factory(:email_confirmed_user)
      sign_in_as @user
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
        response.should redirect_to(callplan_url(@callplan.id))
      end
    end
  end
end
