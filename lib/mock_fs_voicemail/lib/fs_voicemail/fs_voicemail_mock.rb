module MockFSVoicemail

  class FSVoicemailMock

    extend WebmockStubber

    class << self

      #def stub_customer_index(attributes)
        #configure_stub(:get, /\/customers\.xml$/, FSVoicemailResponder.customer_index(attributes))
      #end

      #def stub_customer_create(attributes)
        #body = %r{<customer>\s*<sme-reference>#{attributes["Customer reference"]}</sme-reference>\s*<mobile-number>#{attributes["Mobile number"]}</mobile-number>\s*</customer>}
        #configure_stub_with_body(:post, /\/customers\.xml$/, body, FSVoicemailResponder.customer_create)
      #end

      def stub_voicemail_index url
        configure_stub(:get, url, FSVoicemailResponder.voicemail_index)
      end
    end
  end
end