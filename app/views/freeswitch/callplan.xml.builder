xml.instruct!
xml.document :type => 'freeswitch/xml' do
  xml.section :name => 'dialplan', :description => 'Dynamic Routing' do
    xml.context :name =>'default' do
      xml.extension :name => "#{@inbound_number}" do
        xml.condition :field =>'destination_number', :expression => "^(?:[0-9]{3}|)#{@inbound_number}$" do
          xml.action :application => "#{@callplan.action.application_name}",
            :data => "#{@callplan.action.application_data}"
        end
      end
    end
  end
end

