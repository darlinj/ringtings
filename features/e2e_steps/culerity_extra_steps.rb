require 'culerity'

Before do
  puts "in before"
  $server ||= Culerity::run_server
  $browser = Culerity::RemoteBrowserProxy.new $server, {:browser => :firefox}
  @host = 'http://playpen.local'
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

