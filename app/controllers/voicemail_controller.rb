class VoicemailController < ApplicationController
  before_filter :authenticate
  before_filter :set_tab

  def index
    callplan = current_user.callplan
    @voicemail = Voicemail.new(callplan.inbound_phone_number, callplan.voicemail_password).get
  end

  private
  def set_tab
    @tab="voicemail"
  end
end
