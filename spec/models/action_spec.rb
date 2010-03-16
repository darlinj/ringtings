require 'spec_helper'

describe Action do
  it { should belong_to(:callplan)}
  it { should have_one(:ivr_menu)}
  describe "creating a demo action" do
    before do 
      @inbound_number = "7777777777"
      @target_number = "6666666666"
      @company_name = "Foobar"
      @ivr_menu = Factory.create :ivr_menu
      IvrMenu.stub(:create_demo).and_return @ivr_menu
    end

    def do_create_demo
      Action.create_demo @inbound_number, @target_number, @company_name
    end

    it "returns an action" do
      do_create_demo.should be_a_kind_of Action
    end

    it "has an action type of ivr" do
      do_create_demo.application_name.should == "ivr"
    end

    it "sets the application data" do
      do_create_demo.application_data.should == "ivr_menu_#{@inbound_number}"
    end

    it "sets the ivr menu" do
      do_create_demo.ivr_menu.should == @ivr_menu
    end
  end
end
