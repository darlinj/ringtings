xml.instruct!
xml.document :type => 'freeswitch/xml' do
  xml.section :name => 'configuration' do
    xml.configuration :name=>"ivr.conf", 'description' => "IVR menus" do
      xml.menus do
        xml.menu :name => 'ringtings_menu',
          'tts-engine' => 'Cepstral',
          'tts-voice' => 'Lawrence-8kHz',
          'greet-long' => 'say:This is the Ringtings menu. Wow this really does work.',
          'greet-short' => 'say:This is the Ringtings menu. Wow this really does work.',
          'invalid-sound' => 'say:invalid extension',
          'exit-sound' => 'say:exit sound',
          'timeout' => '15000',
          'max-failures' => '3' do
          xml.entry 'action' => 'menu-exit', 'digits' => "*"
          xml.entry 'action' => 'menu-exec-app', 'digits' => "1", 'param' => "transfer 9996 XML default"
          xml.entry 'action' => 'menu-exec-app', 'digits' => "2", 'param' => "transfer 9999 XML default"
          end
      end
    end
  end
end

