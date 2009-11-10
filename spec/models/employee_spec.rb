require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Employee do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:phone_number).of_type(:string) }
  it { should have_db_column(:email_address).of_type(:string) }
  it { should belong_to(:callplan)}
end
