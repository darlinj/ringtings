xml.instruct!
xml.document :type => 'freeswitch/xml' do
  xml.section :name => 'configuration' do
    xml.configuration :name=>"ivr.conf", 'description' => "IVR menus" do
      xml.menus do
        xml.menu :name => "ivr_menu_#{@callplan.inbound_number.phone_number}",
          'tts-engine' => 'Cepstral',
          'tts-voice' => 'Lawrence-8kHz',
          'greet-long' => "say:Welcome to #{@callplan.company_name}. please press one to be connected to one of our agents or press two to be connected to leave a message",
          'greet-short' => "say:Welcome to #{@callplan.company_name}. please press one to be connected to one of our agents or press two to be connected to leave a message",
          'invalid-sound' => 'say:invalid extension',
          'exit-sound' => 'say:exit sound',
          'timeout' => '15000',
          'max-failures' => '3' do
          xml.entry 'action' => 'menu-exit', 'digits' => "*"
          xml.entry 'action' => 'menu-exec-app', 'digits' => "1", 'param' => "transfer #{@callplan.employee.phone_number} XML default"
          xml.entry 'action' => 'menu-exec-app', 'digits' => "2", 'param' => "transfer 9999 XML default"
          end
      end
    end
  end
end

