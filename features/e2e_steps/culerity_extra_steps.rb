require 'culerity'
require 'uri'

Before do
  puts "in before"
  $server ||= Culerity::run_server
  $browser = Culerity::RemoteBrowserProxy.new $server, {:browser => :firefox}
  @host = 'http://ringtings.test.local'
end

at_exit do
  puts "exiting"
  $browser.exit
  $server.close
end

Given /I am logged out/ do 
  $browser.clear_cookies
end

When /^I press the submit button$/ do
  $browser.button(:type, "submit").click
end

Then /^I should be on (.*)$/ do |path|
  URI.parse($browser.url).path.should == path_to(path)
end

When /^I type "(.*)" in the form field with an HTML id of "(.*)"$/ do |value, id|
  $browser.text_field(:id,id).set(value)
end


When /I click the form input with id "(.*)"/ do |id|
  $browser.text_field(:id, id).click
end


When /I navigate to the "(.*)" for <([^\)]*)>$/ do |target_url,id|
  puts  eval("#{target_url}(#{feature_vars[id]})")
  $browser.goto @host + eval("#{target_url}(#{feature_vars[id]})")
  assert_successful_response 
end
