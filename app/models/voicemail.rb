require 'httparty'

class Voicemail
  include HTTParty

  def initialize username, password
    @auth = {:username => username, :password => password}
  end

  def get
    options = { :basic_auth => @auth }
    response = self.class.get("#{VOICEMAIL_URI}", options)
  end


end
