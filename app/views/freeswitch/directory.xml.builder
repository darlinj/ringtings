xml.instruct!
xml.document :type => 'freeswitch/xml' do
  xml.section :name => 'directory', :description => 'Directory' do
    xml.domain :name => "Somesuch"
  end
end

