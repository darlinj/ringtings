require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Voicemail do
  before do
    @username = "Bob"
    @password = "secret"
    @options = {:basic_auth => {:username => @username, :password => @password}}

    vm1 = {:from => "0123456789",
           :date_created => 1.hour.ago.to_s,
           :priority => "normal",
           :last_heard => 10.minutes.ago.to_s,
           :duration => 10.seconds.to_s,
           :filename => "gibberish.wav"
          }

    vm2 = {:from => "0987654321",
           :date_created => 2.hour.ago.to_s,
           :priority => "low",
           :last_heard => "never",
           :duration => 100.seconds.to_s,
           :filename => "wibbleish.wav"
          }

    @voicemail_response = %Q{
<title>FreeSWITCH Voicemail</title>
<body bgcolor=eeeeee>

<table bgcolor=ffffff width=75% align=center style="border-style:inset;border-width:2px">
<tr><td bgcolor=1010ff align=center valign=center style="border-style:inset;border-width:2px">
<font face=arial size=+2 color=ffffff>Voicemail Messages</font>
</td></tr>
<tr><td>

<font face=tahoma><div class=title><b>Message from Extension #{vm1[:from]} 1000</b></div><hr noshade size=1>
Priority: #{vm1[:priority]}<br>
Created: #{vm1[:date_created]}<br>
Last Heard: #{vm1[:last_heard]}<br>
Duration: #{vm1[:duration]}<br>
<br><object width=550 height=15
type="application/x-shockwave-flash"
data="http://192.168.0.4:8080/pub/slim.swf?song_url=http://192.168.0.4:8080/api/voicemail/get/#{vm1[:filename]}&player_title=Extension%201000%20%3C1000%3E%2007/24/10%2008%3A40%3A10">
<param name=movie value="http://192.168.0.4:8080/pub/slim.swf?song_url=http://192.168.0.4:8080/api/voicemail/get/#{vm1[:filename]}&player_title=Extension%201000%20%3C1000%3E%2007/24/10%2008%3A40%3A10"></object><br><br>
[<a href=http://192.168.0.4:8080/api/voicemail/del/#{vm1[:filename]}>delete</a>] [<a href=http://192.168.0.4:8080/api/voicemail/get/#{vm1[:filename]}>download</a>] [<a href=tel:1000>call</a>] <br><br><br></font>

<font face=tahoma><div class=title><b>Message from Extension #{vm2[:from]} 1000</b></div><hr noshade size=1>
Priority: #{vm2[:priority]}<br>
Created: #{vm2[:date_created]}<br>
Last Heard: #{vm2[:last_heard]}<br>
Duration: #{vm2[:duration]}<br>
<br><object width=550 height=15
type="application/x-shockwave-flash"
data="http://192.168.0.4:8080/pub/slim.swf?song_url=http://192.168.0.4:8080/api/voicemail/get/#{vm2[:filename]}&player_title=Extension%201000%20%3C1000%3E%2007/24/10%2008%3A40%3A10">
<param name=movie value="http://192.168.0.4:8080/pub/slim.swf?song_url=http://192.168.0.4:8080/api/voicemail/get/#{vm2[:filename]}&player_title=Extension%201000%20%3C1000%3E%2007/24/10%2008%3A40%3A10"></object><br><br>
[<a href=http://192.168.0.4:8080/api/voicemail/del/#{vm2[:filename]}>delete</a>] [<a href=http://192.168.0.4:8080/api/voicemail/get/#{vm2[:filename]}>download</a>] [<a href=tel:1000>call</a>] <br><br><br></font>
1 message<br>
</td></tr>
</table>
}

    Voicemail.stub(:get).with(VOICEMAIL_INDEX_URI, @options).and_return(@voicemail_response)

    @voicemails = [vm1,vm2]
  end

  def do_action
    Voicemail.new(@username,@password).index
  end

  describe "#index" do
    it "should set the authentication credentials" do
      Voicemail.should_receive(:get).with(VOICEMAIL_INDEX_URI, @options).and_return(@voicemail_response)
      do_action
    end

    it "should return the list of voicemails" do
      do_action.should == @voicemails
    end
  end
end

describe Voicemail, "#get_wav_file" do
  before do
    @username = "Bob"
    @password = "secret"
    @options = {:basic_auth => {:username => @username, :password => @password}}
  end

  def do_action
    Voicemail.new(@username,@password).get_wav_file("a_wav_file")
  end

  it "should get the file" do
    uri = "#{VOICEMAIL_GET_URI}/a_wav_file.wav"
    Voicemail.should_receive(:get).with(uri, @options)
    do_action
  end
end

describe Voicemail, "#delete_wav_file" do
  before do
    @username = "Bob"
    @password = "secret"
    @options = {:basic_auth => {:username => @username, :password => @password}}
  end

  def do_action
    Voicemail.new(@username,@password).delete_wav_file("a_wav_file")
  end

  it "should delete the file" do
    uri = "#{VOICEMAIL_DELETE_URI}/a_wav_file.wav"
    Voicemail.should_receive(:get).with(uri, @options)
    do_action
  end
end
