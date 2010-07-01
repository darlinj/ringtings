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

