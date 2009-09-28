require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InboundNumberManager do
  it { should have_db_column(:inbound_number).of_type(:string) }
  describe "getting an inbound number from the database" do
    it "grabs the a free number and assigns it to the callplan..."
  end
end
