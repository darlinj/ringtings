require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AudioFile do
  describe "creating a demo audio file" do

    it "calls create_demo and does not return nil" do
      AudioFile.create_demo.should_not be_nil
    end

    it "returns an audio file" do
      AudioFile.create_demo.should be_a_kind_of AudioFile
    end

    it "set has a audio attribute" do
      AudioFile.create_demo.audio.should_not be_nil
    end

    it "sets the filename correctly" do
      AudioFile.create_demo.audio.path.should =~ /.*suckingteeth.wav/
    end

    it "should have an acctual file on the disk" do
      File.exists?(AudioFile.create_demo.audio.path).should be_true
    end
  end
end
