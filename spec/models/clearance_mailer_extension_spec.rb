
require File.dirname(__FILE__) + '/../spec_helper'

describe ClearanceMailer do
  before do
    ActionMailer::Base.delivery_method = :test  
    ActionMailer::Base.perform_deliveries = true  
    ActionMailer::Base.deliveries = []
  end

  def deliver_mail
    @user = Factory.create :user
    ClearanceMailer.deliver_confirmation(@user)  
  end

  it "should deliver 1 email" do
    deliver_mail
    ActionMailer::Base.deliveries.size.should == 1  
  end

  it "should bcc to the admin" do
    mail = deliver_mail
    mail.bcc.should == ["joe.darling@bt.com"]
  end
end
