class VoicemailController < ApplicationController
  before_filter :authenticate
  before_filter :set_tab

  def index
    callplan = current_user.callplan
    @voicemail = Voicemail.new(callplan.inbound_phone_number, callplan.voicemail_password).index
  end

  def show
    file_contents = Voicemail.get_wav_file(params[:id])
    send_data(file_contents, :type =>'audio/wav')
  end

  private
  def set_tab
    @tab="voicemail"
  end
end
