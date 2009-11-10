require File.dirname(__FILE__) + '/../spec_helper'

describe Callplan do
  it { should have_db_column(:company_name).of_type(:string) }
  it { should have_one(:inbound_number)}
  it { should have_one(:action)}
  it { should have_one(:employee)}
end
