require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IvrMenuEntryPrototype do
  before do
    IvrMenuEntryPrototype.create! :name=>"Figgis"
  end
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
