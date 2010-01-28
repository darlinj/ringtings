require 'culerity'
require 'uri'
require 'rexml/document'

Then /^the response should have (.*) elements that match "(.*)"$/ do |count , xpath|
  doc = REXML::Document.new($browser.html).root
  REXML::XPath.first(doc, "count(#{xpath})").should == count.to_i
end

Then /^the response should have an? "(.*)" element$/ do |xpath|
  doc = REXML::Document.new($browser.html).root
  REXML::XPath.match(doc, xpath).should_not be_empty
end

Given /I am logged out/ do 
  $browser.clear_cookies
end

When /^I print the response$/ do
  puts $browser.html
end

When /^I press the submit button$/ do
  $browser.button(:type, "submit").click
end

When /I hit the link with id "(.*)"/ do |identity|
  $browser.link(:id, /#{identity}/).click
end

When /I click the link with id: "(.*)"/ do |text|
  $browser.link(:id, /#{text}/).click
  assert_successful_response
end

When /I click the link with class: "(.*)"/ do |text|
  $browser.link(:class, /#{text}/).click
  assert_successful_response
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
