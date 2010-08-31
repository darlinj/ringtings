xml.instruct!
xml.document :type => 'freeswitch/xml' do
  xml.section :name => 'directory', :description => 'Directory' do
    xml.domain :name => "$${domain}" do
      xml.groups do
        xml.group :name => 'default' do
          xml.users do
            xml.user :id=>@inbound_number do
              xml.params do
                xml.param :name => 'vm-password', :value => @inbound_number_manager.voicemail_password
                xml.param :name => 'http-allowed-api', :value => "voicemail"
              end
            end
          end
        end
      end
    end
  end
end

