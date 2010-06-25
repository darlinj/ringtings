Given %r/^I have 3 voicemail files in my voicemail directory$/ do
  phone_number = @callplan.inbound_number.phone_number
  directory = "#{VOICEMAIL_ROOT}#{phone_number}/"
  FileUtils.mkdir_p directory
  FileUtils.rm Dir.glob("#{directory}*")
  3.times do
    File.new("#{directory}Voicemail#{rand(9999999)}",'w').close
  end
end
