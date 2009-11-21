require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InboundNumberManager do
  it { should have_db_column(:phone_number).of_type(:string) }
  it { should belong_to(:callplan)}
  it { should belong_to(:ivr_menu)}

  describe "getting an inbound number from the database" do
    before do
      @expected_number = "0123456789"
      InboundNumberManager.destroy_all
      Factory :inbound_number_manager, :phone_number=>"0987654322" , :callplan_id=>2
      @expected_inbound_number = Factory :inbound_number_manager, :phone_number=>@expected_number , :callplan_id=>nil
      Factory :inbound_number_manager, :phone_number=>"0987654321" , :callplan_id=>1
      @callplan = Factory :callplan, :company_name => "foobar"
    end
    def do_allocate_free_number_to_callplan
      InboundNumberManager.allocate_free_number_to_callplan @callplan
    end
    it "sets callplan_id to the id of the passed in callplan" do
      do_allocate_free_number_to_callplan
      InboundNumberManager.find_by_phone_number(@expected_number).callplan_id.should == @callplan.id
    end
    describe "if there are no free numbers available" do
      it "will raise an exception of type OutOfCapacityError" do
        InboundNumberManager.destroy_all
        Factory :inbound_number_manager, :phone_number=>"0987654321" , :callplan_id=>1
        lambda {do_allocate_free_number_to_callplan}.should raise_error Exceptions::OutOfCapacityError
      end
    end
  end
end
