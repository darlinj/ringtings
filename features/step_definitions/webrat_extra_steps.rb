Then %r/^I submit the form$/ do
  click_button "next_submit_image"
end

Given %r/^I am logged in$/ do
  steps %Q{
       Given I am signed up and confirmed as "email@person.com/password"
      When I go to the sign in page
      And I sign in as "email@person.com/password"
      Then I should see "Signed in"
      And I should be signed in
  }
end

When %r/^I type "([^\"]*)" in the form field with an HTML id of "([^\"]*)"$/ do |text , id|
  fill_in(field_with_id(id), :with => text)
end

When /^I click the form input with id "([^\"]*)"$/ do |id|
  click_button(id)
end

