Given /^there is a validated user with email "([^\"]*)" and a passord of "([^\"]*)"$/ do |email, password|
  And %{there is no user with ID "#{email}"}
  And %{I am logged out}
  When %{I go to the sign up page}
  And %{I type "#{email}" in the form field with an HTML id of "user_email"}
  And %{I type "#{password}" in the form field with an HTML id of "user_password"}
  And %{I type "#{password}" in the form field with an HTML id of "user_password_confirmation"}
  And %{I click on "Sign up"}
  Then %{I should see "instructions for confirming"}
  And %{I confirm the user "#{email}"}
end

