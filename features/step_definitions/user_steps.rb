
Given /^there is no user with ID "([^\"]*)"$/ do |username|
  User.destroy_all :email=>username
end

Then /^I confirm the user "([^\"]*)"$/ do |username|
  u = User.find_by_email username
  u.email_confirmed = true
  u.save!
end





