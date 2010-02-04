require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IvrMenuEntry do
  it { should belong_to(:ivr_menu)}
  it { should belong_to(:prototype)}
  it { should validate_presence_of(:prototype)}
end
