require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VoicemailController, "successfully" do
  before do
    @directory = VOICEMAIL_ROOT
    @phone_number = "0495093485"
    @mtime1 = "1/2/2010 8:34PM"
    @mtime2 = "3/2/2010 3:34PM"
    dir = "#{@directory}#{@phone_number}"
    inbound_number = mock(InboundNumberManager, :phone_number => @phone_number)
    callplan = mock(Callplan, :inbound_number => inbound_number)
    user = mock(User, :callplan => callplan)
    controller.stub(:current_user).and_return(user)
    @filelist = ["file1","file2"]
    Dir.stub(:glob).and_return(@filelist)
    mockfile1 = mock "file", :mtime=> @mtime1
    mockfile2 = mock "file", :mtime=> @mtime2
    File.stub(:new).and_return(mockfile1,mockfile2)
  end

  it "should respond to index" do
    controller.should respond_to(:index)
  end

  it "should render the correct template" do
    get :index
    response.should render_template('voicemail/index')
  end

  it "should look in the directory" do
    Dir.should_receive(:glob).with("#{@directory}#{@phone_number}/*")
    get :index
  end

  it "will assign the list of directories" do 
    vm1 = { :datetime => @mtime1 }
    vm2 = { :datetime => @mtime2 }
    get :index 
    assigns[:voicemail].should == [vm1,vm2]
  end

  it "should set the tab" do
    get :index
    assigns[:tab].should == "voicemail"
  end
end
