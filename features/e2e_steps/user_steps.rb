Given /^there is a validated user with email "([^\"]*)" and a passord of "([^\"]*)"$/ do |email, password|
  And %{there is no user with ID "#{email}"}
  And %{I am logged out}
  When %{I go to the sign up page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I fill in "Confirm password" with "#{password}"}
  And %{I press the submit button}
  And %{I confirm the user "#{email}"}
end

