require 'httparty'

class Voicemail
  include HTTParty

  def initialize username, password
    @auth = {:username => username, :password => password}
  end

  def get
    options = { :basic_auth => @auth }
    response = self.class.get("#{VOICEMAIL_URI}", options)
    [parse_voicemail_details_from_response(Nokogiri::HTML(response).xpath("//tr[2]"))]
  end

  private

  def parse_voicemail_details_from_response response
    response_text = response.xpath("text()").to_s
    from = response.xpath("//div[@class='title']/b/text()").to_s.split[3]
    date_created = response_text[/Created:.*/].gsub("Created: ", "")
    priority = response_text[/Priority:.*/].gsub("Priority: ", "")
    last_heard = response_text[/Last Heard:.*/].gsub("Last Heard: ", "")
    duration = response_text[/Duration:.*/].gsub("Duration: ", "")
    filename = response.xpath("//a[contains(@href,'get')]/@href").to_s[/\w*\.\w*\Z/]
    {:from => from,
      :date_created => date_created,
      :priority => priority,
      :last_heard => last_heard,
      :duration => duration,
      :filename => filename
    }
  end


end
