xml.instruct!
xml.document :type => 'freeswitch/xml' do
  xml.section :name => 'configuration' do
    xml.configuration :name=>"ivr.conf", 'description' => "IVR menus" do
      xml.menus do
        xml.menu :name => @ivr_menu.name,
          'tts-engine' => 'Cepstral',
          'tts-voice' => 'Lawrence-8kHz',
          'greet-long' => @ivr_menu.long_greeting,
          'greet-short' => @ivr_menu.long_greeting,
          'invalid-sound' => 'say:invalid extension',
          'exit-sound' => 'say:exit sound',
          'timeout' => '15000',
          'max-failures' => '3' do
          @ivr_menu.ivr_menu_entries.each  do |entry|
            xml.entry 'action' => entry.action, 'digits' => entry.digits, 'param' => "#{entry.system_param_part} #{entry.user_param_part}"
          end
        end
      end
    end
  end
end

