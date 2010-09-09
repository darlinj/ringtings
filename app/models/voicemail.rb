require 'httparty'

class Voicemail
  include HTTParty

  def initialize username, password
    @auth = {:basic_auth => {:username => username, :password => password}}
  end

  def index
    response = self.class.get("#{VOICEMAIL_INDEX_URI}", @auth)
    Nokogiri::HTML(response).xpath("//tr[2]//font").map do | vm |
      parse_voicemail_details_from_response(vm)
    end
  end

  def get_wav_file filename
    url = "#{VOICEMAIL_GET_URI}/#{filename}.wav"
    self.class.get(url, @auth)
  end

  private

  def parse_voicemail_details_from_response raw_voicemail_response
    response_text = raw_voicemail_response.xpath("text()").to_s
    from = raw_voicemail_response.xpath(".//div[@class='title']/b/text()").to_s.split[3]
    date_created = response_text[/Created:.*/].gsub("Created: ", "")
    priority = response_text[/Priority:.*/].gsub("Priority: ", "")
    last_heard = response_text[/Last Heard:.*/].gsub("Last Heard: ", "")
    duration = response_text[/Duration:.*/].gsub("Duration: ", "")
    filename = raw_voicemail_response.xpath(".//a[contains(@href,'get')]/@href").to_s[/\w*\.\w*\Z/]
    {:from => from,
      :date_created => date_created,
      :priority => priority,
      :last_heard => last_heard,
      :duration => duration,
      :filename => filename
    }
  end


end
