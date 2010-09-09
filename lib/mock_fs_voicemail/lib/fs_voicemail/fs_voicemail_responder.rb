module MockFSVoicemail

  class FSVoicemailResponder
    class << self

VOICEMAIL_RESPONSE_EMPTY_LIST = %q{
<title>FreeSWITCH Voicemail</title>
<body bgcolor=eeeeee>

<table bgcolor=ffffff width=75% align=center style="border-style:inset;border-width:2px">
<tr><td bgcolor=1010ff align=center valign=center style="border-style:inset;border-width:2px">
<font face=arial size=+2 color=ffffff>Voicemail Messages</font>
</td></tr>
<tr><td>

0 messages<br>
</td></tr>
</table>
}

VOICEMAIL_HEADER = %q{
<title>FreeSWITCH Voicemail</title>
<body bgcolor=eeeeee>

<table bgcolor=ffffff width=75% align=center style="border-style:inset;border-width:2px">
<tr><td bgcolor=1010ff align=center valign=center style="border-style:inset;border-width:2px">
<font face=arial size=+2 color=ffffff>Voicemail Messages</font>
</td></tr>
<tr><td>

}

VOICEMAIL_LINE = %q{
<font face=tahoma><div class=title><b>Message from Extension 1000 1000</b></div><hr noshade size=1>
Priority: normal<br>
Created: Sat, 24 Jul 2010 08:40:10 +0100<br>

Last Heard: Sat, 24 Jul 2010 21:44:36 +0100<br>
Duration: 00:00:08<br>
<br><object width=550 height=15 
type="application/x-shockwave-flash" 
data="http://192.168.0.4:8080/pub/slim.swf?song_url=http://192.168.0.4:8080/api/voicemail/get/<-- wavfile_name -->>
<param name=movie value="http://192.168.0.4:8080/pub/slim.swf?song_url=http://192.168.0.4:8080/api/voicemail/get/<-- wavfile_name -->></object><br><br>
[<a href=http://192.168.0.4:8080/api/voicemail/del/<-- wavfile_name -->>delete</a>] [<a href=http://192.168.0.4:8080/api/voicemail/get/<-- wavfile_name -->>download</a>] [<a href=tel:1000>call</a>] <br><br><br></font>
}

VOICEMAIL_FOOTER = %q{
3 messages<br>

</td></tr>
</table>
}

        def voicemail_file response_content
          [ 200, {'Content-Type' => 'audio/wav'}, response_content]
        end

        def voicemail_index_empty_list
          [ 200, {'Content-Type' => 'text/html'}, VOICEMAIL_RESPONSE_EMPTY_LIST]
        end

        def voicemail_index voicemails
          response = VOICEMAIL_HEADER
          voicemails.each do |voicemail|
            response << VOICEMAIL_LINE.gsub("<-- wavfile_name -->",voicemail[:file_name])
          end
          response << VOICEMAIL_FOOTER
          [ 200, {'Content-Type' => 'text/html'}, response]
        end
    end

  end
end

