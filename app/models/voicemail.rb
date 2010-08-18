require 'httparty'

class Voicemail
  include HTTParty

  def initialize username, password
    @auth = {:username => username, :password => password}
  end

  def get
    options = { :basic_auth => @auth }
    response = self.class.get("#{VOICEMAIL_URI}", options)
    Nokogiri::HTML(response).xpath("//tr[2]//font").map do | vm |
      parse_voicemail_details_from_response(vm)
    end
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
