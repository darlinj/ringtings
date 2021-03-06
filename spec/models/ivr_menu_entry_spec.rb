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
      @destination_number = "03333333333"
      @expected_param_1 = "443333333333"
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

    describe "when the destination number begins with 0" do
      it "sets param1 to the right number" do
        do_create_demo.param_1.should == @expected_param_1
      end
    end

    describe "when the destination number begins with 44" do
      it "sets param1 to the right number" do
        @destination_number = "443333333333"
        do_create_demo.param_1.should == @expected_param_1
      end
    end

    it "creates an error when the phone number is too short" do
      @destination_number = "1234567"
      do_create_demo.errors.should_not be_empty
    end

    it "creates an error when the phone number is too long" do
      @destination_number = "12345678901234"
      do_create_demo.errors.should_not be_empty
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

describe IvrMenuEntry, "saving an ivr menus" do
  before do
    menu_entry1 = IvrMenuEntry.create!(:digits => "1",:ivr_menu_id => 1,:prototype => IvrMenuEntryPrototype.find_by_name("MenuExitMenuEntry"))
    @menu_entry2 = IvrMenuEntry.new(:digits => "1",:ivr_menu_id => 1,:prototype => IvrMenuEntryPrototype.find_by_name("MenuExitMenuEntry"))
  end

  it "should validate that all the ivr_menu_items have a unique number assigned" do
    @menu_entry2.save
    @menu_entry2.errors.should_not be_empty
  end

  it "should fail to save" do
    @menu_entry2.save.should be_false
  end

  it "should set the error message" do
    @menu_entry2.save
    @menu_entry2.errors.full_messages.should include("A key press is assigned to more than one menu option.")
  end
end


