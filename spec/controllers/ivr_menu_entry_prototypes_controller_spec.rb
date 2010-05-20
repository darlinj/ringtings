require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IvrMenuEntryPrototypesController do
  describe "listing the prototypes" do
    before do
      @ivr_menu_entry_prototype1 = mock_model IvrMenuEntryPrototype
      @ivr_menu_entry_prototype1 = mock_model IvrMenuEntryPrototype
      @ivr_menu_entry_prototypes = [@ivr_menu_entry_prototype1,@ivr_menu_entry_prototype2]
      IvrMenuEntryPrototype.stub(:all).and_return @ivr_menu_entry_prototypes
      @ivr_menu = mock_model IvrMenu
    end
    def do_get
      get :index, :ivr_menu_id=>@ivr_menu.id
    end
    it "looks up the prototypes" do
      IvrMenuEntryPrototype.should_receive(:all)
      do_get
    end

    it "assigns the variable for the view" do
      do_get
      assigns[:ivr_menu_entry_prototypes].should == @ivr_menu_entry_prototypes
    end

    it "assigns the ivr_menu that we are working on" do
      do_get
      assigns[:ivr_menu_id].should == @ivr_menu.id.to_s
    end

    it "is sucessful" do
      do_get
      response.should be_success
    end

    describe "requesting html" do
      it "should render the right template" do
        do_get
        response.should render_template("index")
      end
    end

    describe "requesting javascript" do
      it "should render the right template" do
        get :index, :ivr_menu_id=>@ivr_menu.id, :format => "js"
        response.should render_template("index.js")
      end
    end
  end
end
