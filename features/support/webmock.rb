require 'mock_fs_voicemail/mock_fs_voicemail'

World(MockFSVoicemail)

include MockFSVoicemail

Before do
  WebMock.disable_net_connect!
  WebMock.reset_webmock
end



