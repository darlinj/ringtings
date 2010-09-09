Given %r/^I mock (\d+) voicemail messages in my voicemail$/ do | number_of_voicemail |
  phone_number = @callplan.inbound_phone_number
  voicemail_password = @callplan.voicemail_password
  url =  VOICEMAIL_INDEX_URI.sub('http://', "http://#{phone_number}:#{voicemail_password}@")
  @voicemails = number_of_voicemail.to_i.times.map{|n| {:file_name => "file#{n}.wav"} }
  FSVoicemailMock.stub_voicemail_index(url, @voicemails)
end

Given %r/^I mock a empty voicemail response$/ do
  phone_number = @callplan.inbound_phone_number
  voicemail_password = @callplan.voicemail_password
  url =  VOICEMAIL_INDEX_URI.sub('http://', "http://#{phone_number}:#{voicemail_password}@")
  FSVoicemailMock.stub_voicemail_index_empty_list(url)
end

Given %r/^I mock a voicemail file response$/ do
  phone_number = @callplan.inbound_phone_number
  voicemail_password = @callplan.voicemail_password
  url =  VOICEMAIL_GET_URI.sub('http://', "http://#{phone_number}:#{voicemail_password}@")
  url << "/#{@voicemails[0][:file_name]}"
  FSVoicemailMock.stub_voicemail_file_get(url, "I am pretending to be a wav file" )
end

When %r/^I click on the first Download link$/ do 
  click_link("download_#{@voicemails[0][:file_name]}")
end

Then %r/^I should receive a file in the response$/ do
  response.body.should == "I am pretending to be a wav file"
end

