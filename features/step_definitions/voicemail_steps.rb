Given %r/^I mock (\d+) voicemail messages in my voicemail$/ do | number_of_voicemail |
  phone_number = @callplan.inbound_phone_number
  voicemail_password = @callplan.voicemail_password
  #stub_request(:get, VOICEMAIL_URI.sub('http://', "http://#{phone_number}:#{voicemail_password}@")).to_return(:body => VOICEMAIL_RESPONSE, :status => 200,  :headers => { 'Content-Length' => 3 } )
  url =  VOICEMAIL_URI.sub('http://', "http://#{phone_number}:#{voicemail_password}@")

  FSVoicemailMock.stub_voicemail_index(url)
end

Given %r/^I mock a empty voicemail response$/ do
  phone_number = @callplan.inbound_phone_number
  voicemail_password = @callplan.voicemail_password
  url =  VOICEMAIL_URI.sub('http://', "http://#{phone_number}:#{voicemail_password}@")
  FSVoicemailMock.stub_voicemail_index_empty_list(url)
end

