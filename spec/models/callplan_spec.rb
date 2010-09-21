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
      InboundNumberManager.destroy_all
      @company_name  = "Mr biggles flying circus"
      @ivr_menu = Factory.create :ivr_menu
      @action = Factory.create :action, :ivr_menu => @ivr_menu
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

    it "sets the inbound number link" do
      cp = do_create_demo
      cp.inbound_number.ivr_menu.should == cp.action.ivr_menu
    end

    it "sets the employee" do
      do_create_demo.employee.should_not be_nil
    end

    it "sets the employee phone number correctly" do
      do_create_demo.employee.phone_number.should == @target_phone_number
    end

    it "should send an email to the admin" do
      NotificationMailer.should_receive(:deliver_trying_it)
      do_create_demo
    end
  end

  describe "expiring abandoned callplans" do
    before do
      @expired_callplan = Factory.create :callplan
      Factory.create :inbound_number_manager
      @inbound_number = InboundNumberManager.allocate_free_number_to_callplan(@expired_callplan)
      Callplan.record_timestamps = false
      @expired_callplan.updated_at = 2.hours.ago
      @expired_callplan.save
      Callplan.record_timestamps = true

      @non_expired_callplan = Factory.create :callplan

      @user = Factory.create :user
      @callplan_with_user_attached = Factory.create :callplan
      Callplan.record_timestamps = false
      @callplan_with_user_attached.updated_at = 2.hours.ago
      @callplan_with_user_attached.user = @user
      @callplan_with_user_attached.save
      Callplan.record_timestamps = true
    end

    def do_expire_callplans
      Callplan.expire_abandoned_callplans
    end

    it "deletes the callplan that has not been modified in 1 hour and does not have a user attached" do
      do_expire_callplans
      lambda {Callplan.find(@expired_callplan.id)}.should raise_error
    end

    it "does not delete non expired callplans" do
      do_expire_callplans
      Callplan.find(@non_expired_callplan.id).should == @non_expired_callplan
    end

    it "only deletes records that don't belong to a user that has signed up" do
      do_expire_callplans
      Callplan.find(@callplan_with_user_attached.id).should == @callplan_with_user_attached
    end

    it "frees up the inbound number" do
      do_expire_callplans
      InboundNumberManager.find(@inbound_number.id).callplan_id.should be_nil
    end

  end

  describe "inbound phone number" do
    it "should return the phone number" do
      inbound_number = Factory.create(:inbound_number_manager, :phone_number => "247192347928")
      callplan = Factory.create(:callplan, :inbound_number => inbound_number)
      callplan.inbound_phone_number.should == inbound_number.phone_number
    end
  end

  describe "voicemail password" do
    it "should return the voicemail password" do
      inbound_number = Factory.create(:inbound_number_manager, :voicemail_password => "secret")
      callplan = Factory.create(:callplan, :inbound_number => inbound_number)
      callplan.voicemail_password.should == inbound_number.voicemail_password
    end
  end
end
