require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlayAudioFileMenuEntriesController do
  describe "the edit action" do
    before do
      @play_audio_file_ivr_menu = mock_model PlayAudioFileMenuEntry
      PlayAudioFileMenuEntry.stub(:find).and_return(@play_audio_file_ivr_menu)
    end

    def do_get 
      get :edit, :id =>@play_audio_file_ivr_menu.id
    end

    it "responds to edit" do
      do_get
      response.should be_success
    end

    it "renders the edit template" do
      do_get
      response.should render_template('play_audio_file_menu_entries/edit')
    end

    it "sets the @play_audio_file_ivr_menu to the right value" do
      do_get
      assigns[:play_audio_file_ivr_menu].should == @play_audio_file_ivr_menu
    end

  end

  describe "the update action" do
    before do
      @callplan = mock_model Callplan
      @action = mock_model Action, :callplan => @callplan
      @ivr_menu = mock_model IvrMenu, :action => @action
      @filename = "suckingteeth.wav"
      @filepath = "./freeswitch_stuff/#{@filename}"
      @file = ActionController::TestUploadedFile.new(@filepath)
      @ivr_menu_form_params = { :audio => @file }
      @play_audio_file_ivr_menu = Factory :play_audio_file_menu_entry, :ivr_menu => @ivr_menu
      controller.stub(:redirect_to_callplan)
    end

    def do_put 
      put :update, :id=>@play_audio_file_ivr_menu.id, :play_audio_file_menu_entry => @ivr_menu_form_params
    end

    it "creates an audio file" do
      do_put
      AudioFile.last.audio_file_name.should == @filename
    end

    it "attached the audio file to the menu entry" do
      do_put
      PlayAudioFileMenuEntry.find(@play_audio_file_ivr_menu).audio_file.audio_file_name.should == @filename
    end

    it "redirects to the callplan" do
      controller.should_receive(:redirect_to_callplan).with(PlayAudioFileMenuEntry.find(@play_audio_file_ivr_menu))
      do_put
    end

    it "should set the flash to apropriate text" do
      do_put
      flash[:notice].should == "Callplan sucessfully saved"
    end
  end
end
