require File.dirname(__FILE__) + '/../spec_helper'

describe Callplan do
  it { should have_db_column(:company_name).of_type(:string) }
  it { should have_db_column(:user_id).of_type(:integer) }
  it { should have_one(:inbound_number)}
  it { should have_one(:action)}
  it { should have_one(:employee)}
  it { should belong_to(:user)}

  describe "creating a demo callplan" do
    before do
      @company_name  = "Mr biggles flying circus"
      @action = Factory.create :action 
      Action.stub(:create_demo).and_return @action
      @phone_number = "88888888888"
      @target_phone_number = "99999999999"
      @inbound_number = Factory.create :inbound_number_manager, :phone_number => @phone_number
    end

    def do_create_demo
      Callplan.create_demo @target_phone_number, @company_name
    end

    it "will return a callplan" do
      do_create_demo.should be_a_kind_of Callplan
    end

    it "sets the company name" do
      do_create_demo.company_name.should == @company_name
    end

    it "sets the action" do
      do_create_demo.action.should == @action
    end
    
    it "should create the action with the right params" do
      Action.should_receive(:create_demo).with( @phone_number, @target_phone_number, @company_name )
      do_create_demo
    end

    it "allocates the inbound number" do
      do_create_demo.inbound_number.should_not be_nil 
    end

    it "should be the right phone number" do
      do_create_demo.inbound_number.phone_number.should == @phone_number
    end
  end
end
