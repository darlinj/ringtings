require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  it { should have_one(:callplan)}
  it { should have_many(:audio_files)}
end
