Then /^a confirmation message should be bcc'd to "(.*)"$/ do |email|
  sent = ActionMailer::Base.deliveries.first
  assert_equal [email], sent.bcc
  assert_match /confirm/i, sent.subject
end

Then /^an email message should be sent to "(.*)"$/ do |email|
  puts ActionMailer::Base.deliveries.inspect
  sent = ActionMailer::Base.deliveries.first
  assert_equal [email], sent.to
end


