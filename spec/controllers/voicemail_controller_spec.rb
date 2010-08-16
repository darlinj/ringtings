require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VoicemailController, "successfully" do
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
    @voicemail = mock(Voicemail, :get => @voicemails)
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
    @voicemail.should_receive(:get)
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
