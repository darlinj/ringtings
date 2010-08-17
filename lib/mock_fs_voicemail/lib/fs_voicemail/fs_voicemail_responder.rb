module MockFSVoicemail

  class FSVoicemailResponder
    class << self

VOICEMAIL_RESPONSE = %q{
<title>FreeSWITCH Voicemail</title>
<body bgcolor=eeeeee>

<table bgcolor=ffffff width=75% align=center style="border-style:inset;border-width:2px">
<tr><td bgcolor=1010ff align=center valign=center style="border-style:inset;border-width:2px">
<font face=arial size=+2 color=ffffff>Voicemail Messages</font>
</td></tr>
<tr><td>

<font face=tahoma><div class=title><b>Message from Extension 1000 1000</b></div><hr noshade size=1>
Priority: normal<br>
Created: Sat, 24 Jul 2010 08:40:10 +0100<br>
Last Heard: Sat, 24 Jul 2010 21:44:36 +0100<br>
Duration: 00:00:08<br>
<br><object width=550 height=15
type="application/x-shockwave-flash"
data="http://192.168.0.4:8080/pub/slim.swf?song_url=http://192.168.0.4:8080/api/voicemail/get/msg_9b093738-96f6-11df-a7db-c3487799bb98.wav&player_title=Extension%201000%20%3C1000%3E%2007/24/10%2008%3A40%3A10">
<param name=movie value="http://192.168.0.4:8080/pub/slim.swf?song_url=http://192.168.0.4:8080/api/voicemail/get/msg_9b093738-96f6-11df-a7db-c3487799bb98.wav&player_title=Extension%201000%20%3C1000%3E%2007/24/10%2008%3A40%3A10"></object><br><br>
[<a href=http://192.168.0.4:8080/api/voicemail/del/msg_9b093738-96f6-11df-a7db-c3487799bb98.wav>delete</a>] [<a href=http://192.168.0.4:8080/api/voicemail/get/msg_9b093738-96f6-11df-a7db-c3487799bb98.wav>download</a>] [<a href=tel:1000>call</a>] <br><br><br></font>
1 message<br>
</td></tr>
</table>
}

        def voicemail_index
          [ 200, {'Content-Type' => 'text/html'}, VOICEMAIL_RESPONSE]
        end
      #def customer_index(attributes)
        #return index_empty if attributes.empty?

        #response_xml = XML_HEADER + "{<customers type=\"array\">"
        #attributes.each do |customer|
          #response_xml += sprintf(CUSTOMER_ITEM_XML, customer[:id], customer[:sme_reference])
        #end
        #response_xml += %q{</customers>}
        #[200, {'Content-Type' => 'application/xml'}, response_xml]
      #end
    end

  end
end
