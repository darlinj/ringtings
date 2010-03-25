module ClearanceMailerExtension
  def self.enable
    ClearanceMailer.send :include, self
  end

  def self.included base
    base.class_eval do
      include InstanceMethods
      alias_method_chain :confirmation, :bcc
    end
  end

  module InstanceMethods
    def confirmation_with_bcc user
      from       DO_NOT_REPLY
      bcc        ADMIN_EMAIL
      recipients user.email
      subject    I18n.t(:confirmation,
                        :scope   => [:clearance, :models, :clearance_mailer],
                        :default => "Account confirmation")
      body      :user => user
    end
  end
end
