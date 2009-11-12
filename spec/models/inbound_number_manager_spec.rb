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
      Factory :inbound_number_manager, :phone_number=>@expected_number , :callplan_id=>nil
      Factory :inbound_number_manager, :phone_number=>"0987654321" , :callplan_id=>1
    end
    def do_get_free_number
      InboundNumberManager.get_free_number 
    end
    it "grabs the a free number" do
      do_get_free_number.phone_number.should == @expected_number
    end
    describe "if there are no free numbers available" do
      it "will raise an exception of type OutOfCapacityError" do
        InboundNumberManager.destroy_all
        Factory :inbound_number_manager, :phone_number=>"0987654321" , :callplan_id=>1
        lambda {do_get_free_number}.should raise_error Exceptions::OutOfCapacityError
      end
    end
  end
end
