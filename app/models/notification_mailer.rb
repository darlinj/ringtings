class NotificationMailer < ActionMailer::Base
  default_url_options[:host] = HOST

  def trying_it
    from       DO_NOT_REPLY
    recipients ADMIN_EMAIL
    subject    "Someone created a callplan on ringtings!"
    body       "Honestly!"
  end

end
