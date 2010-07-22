class VoicemailController < ApplicationController
  before_filter :authenticate
  before_filter :set_tab

  def index
    directory = "#{VOICEMAIL_ROOT}#{current_user.callplan.inbound_number.phone_number}/*"
    @voicemail = Dir.glob(directory).map do |file|
      {:datetime => File.new(file).mtime}
    end
  end

  private
  def set_tab
    @tab="voicemail"
  end
end
