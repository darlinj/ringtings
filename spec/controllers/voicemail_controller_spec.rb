require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VoicemailController, "index" do
  before do
    @inbound_phone_number = "54783754"
    @voicemail_password = "secret"
    @mtime1 = "1/2/2010 8:34PM"
    @mtime2 = "3/2/2010 3:34PM"
    vm1 = mock("Voicemail")
    vm2 = mock("Voicemail")
    @voicemails = [vm1,vm2]
    @callplan = mock(Callplan, :inbound_phone_number => @inbound_phone_number,
                     :voicemail_password => @voicemail_password)
    user = mock(User, :callplan => @callplan)
    controller.stub(:current_user).and_return(user)
    @voicemail = mock(Voicemail, :index => @voicemails)
    Voicemail.stub(:new).and_return(@voicemail)
  end

  it "should respond to index" do
    controller.should respond_to(:index)
  end

  it "should render the correct template" do
    get :index
    response.should render_template('voicemail/index')
  end

  it "will create the voicemail object with the credentials" do
    Voicemail.should_receive(:new).with(@inbound_phone_number, @voicemail_password)
    get :index
  end

  it "will get the list of voicemail from the model" do
    @voicemail.should_receive(:index)
    get :index
  end

  it "will assign the list of voicemails" do
    get :index
    assigns[:voicemail].should == @voicemails
  end

  it "should set the tab" do
    get :index
    assigns[:tab].should == "voicemail"
  end
end

describe VoicemailController, "index - when the user hasn't got a callplan" do
  before do
    user = mock(User, :callplan => nil)
    controller.stub(:current_user).and_return(user)
  end

  it "will assign the list of voicemails to nil" do
    get :index
    assigns[:voicemail].should == []
  end
end

describe VoicemailController, ".show" do
  before do
    @wav_file_contents = "a wav file full of data"
    @voicemail = mock(Voicemail)
    Voicemail.stub(:new).and_return @voicemail
    @voicemail.stub(:get_wav_file).and_return(@wav_file_contents)
    @callplan = mock(Callplan, :inbound_phone_number => @inbound_phone_number,
                     :voicemail_password => @voicemail_password)
    user = mock(User, :callplan => @callplan)
    controller.stub(:current_user).and_return(user)
  end

  def do_action
    get :show, :id =>"foo"
  end

  it "should get the wav file" do
    @voicemail.should_receive(:get_wav_file).with("foo")
    do_action
  end

  it "should render the wav file" do
    controller.should_receive(:send_data).with(@wav_file_contents,:type =>  'audio/wav')
    do_action
  end
end

describe VoicemailController, ".delete" do
  before do
    @voicemail = mock(Voicemail)
    Voicemail.stub(:new).and_return @voicemail
    @voicemail.stub(:delete_wav_file)
    @callplan = mock(Callplan, :inbound_phone_number => @inbound_phone_number,
                     :voicemail_password => @voicemail_password)
    user = mock(User, :callplan => @callplan)
    controller.stub(:current_user).and_return(user)
  end

  def do_action
    delete :destroy, :id =>"foo"
  end

  it "should get the wav file" do
    @voicemail.should_receive(:delete_wav_file).with("foo")
    do_action
  end

  it "should redirect to index" do
    do_action
    response.should redirect_to(:action => 'index')
  end
end
