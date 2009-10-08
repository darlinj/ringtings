xml.instruct!
xml.document :type => 'freeswitch/xml' do
  xml.section :name => 'dialplan', :description => 'Dynamic Routing' do
    xml.context :name =>'default' do
      xml.extension :name => "#{@number_matcher}" do
        xml.condition :field =>'destination_number', :expression => '^(?:[0-9]{3}|)5006$' do
          xml.action :application => 'speak', :data => "cepstral|lawrence|#{@say_phrase}"
        end
      end
    end
  end
end

