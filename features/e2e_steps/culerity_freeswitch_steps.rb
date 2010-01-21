require 'culerity'
require 'uri'

When /Freeswitch posts "(.*)" parameters to "(.*)"/ do |parameters,url|
  curl_response = Curl::Easy.http_post(url,parameters)
  xml_response = curl_response.body_str
  @xml_doc = REXML::Document.new xml_response
end

When /Freeswitch posts to "(.*)"/ do |url|
  curl_response = Curl::Easy.http_post(url)
  xml_response = curl_response.body_str
  @xml_doc = REXML::Document.new xml_response
end

Then /Freeswitch should find "(.*)" in the XML/ do |value|
  assert_match /#{value}/i, @xml_doc.to_s
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



