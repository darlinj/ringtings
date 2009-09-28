require 'culerity'
require 'uri'

Before do
  puts "in before"
  $freeswitch_server ||= Culerity::run_server
  $freeswitch_browser = Culerity::RemoteBrowserProxy.new $freeswitch_server, {:browser => :firefox}
  @host = 'http://ringtings.local'
end

at_exit do
  puts "exiting"
  $freeswitch_browser.exit
  $freeswitch_server.close
end


When /Freeswitch goes to (.+)/ do |path|
  $freeswitch_browser.goto @host + path_to(path)
  assert_successful_response
end

Then /Freeswitch should see "(.*)"/ do |text|
  # if we simply check for the browser.html content we don't find content that has been added dynamically, e.g. after an ajax call
  div = $freeswitch_browser.div(:text, /#{text}/)
  begin
    div.html
  rescue
    puts $freeswitch_browser.html
    raise("div with '#{text}' not found")
  end
end



