require File.dirname(__FILE__) + '/../spec_helper'

describe NotificationMailer do
  before do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  def deliver_mail
    NotificationMailer.deliver_trying_it
  end

  it "should deliver 1 email" do
    deliver_mail
    ActionMailer::Base.deliveries.size.should == 1
  end

  it "should mail to the admin" do
    mail = deliver_mail
    mail.to.should == [ADMIN_EMAIL]
  end
end
