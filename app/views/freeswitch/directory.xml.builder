xml.instruct!
xml.document :type => 'freeswitch/xml' do
  xml.section :name => 'directory', :description => 'Directory' do
    xml.domain :name => "$${domain}" do
      xml.groups do
        xml.group :name => 'default' do
          xml.users do
            xml.user :id=>@inbound_number
          end
        end
      end
    end
  end
end

