Then %r{^the xml node "([^\"]*)" should contain "(.*)"$} do |node, value|
  xml_node_value(response.body, node).should =~ /#{value}/
end

Then %r{^the xml node "([^\"]*)" should be "(.*)"$} do |node, value|
  xml_node_value(response.body, node).should == value
end

Then %r/^there should be an xml node "([^\"]*)" containing "([^\"]*)"$/ do |node, value|
  xml_node_values(response.body, node).should include(value)
end

Then %r/^there should not be an xml node "([^\"]*)" containing "([^\"]*)"$/ do |node, value|
  xml_node_values(response.body, node).should_not include(value)
end

Then %r/^the response should have (\d*) elements that match "([^\"]*)"$/ do |number, xpath|
  xml_node_values(response.body, xpath).count.should == number.to_i
end
