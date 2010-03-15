require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlayAudioFileMenuEntry do
  describe "creating a demo entry" do
    before do
      @ivr_digit = "1"
      @audio_file_path = "/some/path/to/a/file.wav"
      @audio_file_object = mock :audio_file_object, :path => @audio_file_path
      @audio_file = mock_model AudioFile, :audio => @audio_file_object
    end

    def do_create_demo 
      PlayAudioFileMenuEntry.create_demo @ivr_digit, @audio_file
    end

    it "returns a entry" do
      do_create_demo.should be_a_kind_of PlayAudioFileMenuEntry
    end

    it "should assign the right ivr_digit" do
      do_create_demo.digits.should == @ivr_digit
    end

    it "assigns the right prototype" do
      do_create_demo.prototype.name.should == "PlayAudioFileMenuEntry"
    end

    it "sets param1 to the right number" do
      do_create_demo.audio_file.should == @audio_file
    end

    it "sets param_1 to the path of the audiofile" do
      do_create_demo.param_1.should == @audio_file_path
    end
  end

end
