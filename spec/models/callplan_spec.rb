require File.dirname(__FILE__) + '/../spec_helper'

describe Callplan do

  it { should have_db_column(:company_name).of_type(:string) }
  it { should have_one(:inbound_number)}

  describe "creating a new call plan" do
    before do
      @company_name = "fishy smells r us"
      @phone_number = "0123456789"
      InboundNumberManager.destroy_all
      Factory :inbound_number_manager, :phone_number=>@phone_number , :callplan_id=>nil
    end
    def do_generate
      Callplan.generate :company_name=>@company_name
    end
    it "assigns an inbound number to the plan" do
      InboundNumberManager.should_receive(:get_free_number)
      do_generate
    end
    it "returns the callplan object with an inbound number attached" do
      do_generate.inbound_number.phone_number.should == @phone_number
    end
  end
end
