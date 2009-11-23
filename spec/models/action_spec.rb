require 'spec_helper'

describe Action do
  it { should belong_to(:callplan)}
  it { should have_one(:ivr_menu)}
end
