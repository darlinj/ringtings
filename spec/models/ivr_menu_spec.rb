require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IvrMenu do
  it { should have_one(:inbound_number_manager)}
  it { should have_many(:ivr_menu_entries)}
end
