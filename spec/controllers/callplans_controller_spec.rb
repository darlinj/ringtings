require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CallplansController do
  describe "the demo call plans resource" do
    before do
      @tab="callplans"
    end
    describe "the show" do
      def do_get 
        get :show, :id => 1
      end
      it "responds to show" do
        do_get
        response.should be_success
      end
      it "renders the index template" do
        do_get 
        response.should render_template('callplans/show')
      end
    end
  end
end
