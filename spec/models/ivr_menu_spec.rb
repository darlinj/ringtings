require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IvrMenu do
  it { should have_one(:inbound_number_manager)}
  it { should have_many(:ivr_menu_entries)}
  it { should belong_to(:action)}

  describe "creating a demo ivr menu" do
    before do
      @company_name = "foobars"
      @inbound_number = "01234567890"
      @target_phone_number = "09876543210"
    end
    def do_demo_create
      IvrMenu.create_demo @company_name, @inbound_number, @target_phone_number
    end
    it "returns an ivr menu object" do
      do_demo_create.should be_a_kind_of IvrMenu
    end

    it "should set the greeting" do
      do_demo_create.long_greeting.should =~ /Welcome to #{@company_name}/
    end

    it "sets the name of the menu" do
      do_demo_create.name.should == "ivr_menu_#{@inbound_number}"
    end

    it "has 6 ivr menu entries" do
      do_demo_create.ivr_menu_entries.count.should == 5
    end

    it "has one call tranfer menu" do
      do_demo_create.ivr_menu_entries[0].should be_a_kind_of TransferCallMenuEntry
    end

    it "has one voicemail" do
      do_demo_create.ivr_menu_entries[1].should be_a_kind_of VoiceMailMenuEntry
    end

    it "has three play audio file menus" do
      do_demo_create.ivr_menu_entries[2].should be_a_kind_of PlayAudioFileMenuEntry
      do_demo_create.ivr_menu_entries[3].should be_a_kind_of PlayAudioFileMenuEntry
      do_demo_create.ivr_menu_entries[4].should be_a_kind_of PlayAudioFileMenuEntry
    end
  end
end
