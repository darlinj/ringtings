require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IvrMenuEntry do
  it { should belong_to(:ivr_menu)}
  it { should belong_to(:audio_file)}
  it { should belong_to(:prototype)}
  it { should validate_presence_of(:prototype)}
end

describe MenuExitMenuEntry do
  describe "creating a demo entry" do
    before do
      @ivr_digit = "*"
    end

    def do_create_demo 
      MenuExitMenuEntry.create_demo @ivr_digit
    end

    it "returns a entry" do
      do_create_demo.should be_a_kind_of MenuExitMenuEntry
    end

    it "should assign the right ivr_digit" do
      do_create_demo.digits.should == @ivr_digit
    end

    it "assigns the right prototype" do
      do_create_demo.prototype.name.should == "MenuExitMenuEntry"
    end
  end
end



describe TransferCallMenuEntry do
  describe "creating a demo entry" do
    before do
      @ivr_digit = "1"
      @destination_number = "333333333333"
    end

    def do_create_demo 
      TransferCallMenuEntry.create_demo @ivr_digit, @destination_number
    end

    it "returns a entry" do
      do_create_demo.should be_a_kind_of TransferCallMenuEntry
    end

    it "should assign the right ivr_digit" do
      do_create_demo.digits.should == @ivr_digit
    end

    it "assigns the right prototype" do
      do_create_demo.prototype.name.should == "TransferCallMenuEntry"
    end

    it "sets param1 to the right number" do
      do_create_demo.param_1.should == @destination_number
    end
  end
end

describe VoiceMailMenuEntry do
  describe "creating a demo entry" do
    before do
      @ivr_digit = "9"
    end

    def do_create_demo 
      VoiceMailMenuEntry.create_demo @ivr_digit
    end

    it "returns a entry" do
      do_create_demo.should be_a_kind_of VoiceMailMenuEntry
    end

    it "should assign the right ivr_digit" do
      do_create_demo.digits.should == @ivr_digit
    end

    it "assigns the right prototype" do
      do_create_demo.prototype.name.should == "VoiceMailMenuEntry"
    end
  end
end




