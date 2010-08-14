class VoicemailController < ApplicationController
  before_filter :authenticate

  def index
    callplan = current_user.callplan
    @voicemail = Voicemail.new(callplan.inbound_phone_number, callplan.voicemail_password).get
  end
end
