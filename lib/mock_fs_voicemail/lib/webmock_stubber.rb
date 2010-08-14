module MockFSVoicemail

  module WebmockStubber

    def configure_stub(method, url, rack_response)
      rack_responses = rack_response[0].is_a?(Array) ? rack_response : [rack_response]
      WebMock.stub_request(method, url).to_return(rack_responses.map { |r| {:status => r[0], :body => r[2], :headers => r[1] }})
    end

    def configure_stub_with_headers(method, url, headers, rack_response)
      rack_responses = rack_response[0].is_a?(Array) ? rack_response : [rack_response]
      WebMock.stub_request(method, url).with(:headers => headers).to_return(rack_responses.map { |r| {:status => r[0], :body => r[2], :headers => r[1] }})
    end

    def configure_stub_with_body(method, url, body, rack_response)
      rack_responses = rack_response[0].is_a?(Array) ? rack_response : [rack_response]
      WebMock.stub_request(method, url).with(:body => body).to_return(rack_responses.map { |r| {:status => r[0], :body => r[2], :headers => r[1]} })
    end

    def configure_stub_with_body_and_headers(method, url, body, headers, rack_response)
      rack_responses = rack_response[0].is_a?(Array) ? rack_response : [rack_response]
      WebMock.stub_request(method, url).with(:body => body, :headers => headers).to_return(rack_responses.map { |r| {:status => r[0], :body => r[2], :headers => r[1]} })
    end
  end
end
