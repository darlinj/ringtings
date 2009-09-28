require File.dirname(__FILE__) + '/../spec_helper'

describe Callplan do

  it { should have_db_column(:company_name).of_type(:string) }
  it { should have_db_column(:inbound_number).of_type(:string) }

  describe "creating a new call plan" do
    before do
      @company_name = "fishy smells r us"
      @inbound_number = "0123456789"
      InboundNumberManager.stub(:get_free_number).and_return @inbound_number
    end
    def do_create
      Callplan.create! :company_name=>@company_name
    end
    it "assigns an inbound number to the plan" do
      InboundNumberManager.should_receive(:get_free_number)
      do_create
    end
    it "returns the callplan object" do
      do_create.inbound_number.should == @inbound_number
    end
  end
end
