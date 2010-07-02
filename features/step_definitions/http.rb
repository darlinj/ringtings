# Makes an HTTP request with no params or headers. Eg:
#   When a client requests GET /hosts
When %r/a client requests (\S*) (\S*)$/ do |verb, path|
  make_request verb, path
end
#
# Makes an HTTP request with params, headers and/or auth values (username &
# password) specified in a table. Eg:
#   When a client requests POST /hosts with:
#   | type   | name                 | value  |
#   | param  | service_type         | foo    |
#   | header | X-BT-Correlation-Id  | 42     |
#   | auth   | username             | bob    |
#   | auth   | password             | secret |
When %r/a client requests (\S*) (\S*) with:/ do |verb, path, table|
  make_request verb, path, table
end

Then %r/^the response should have a "(.*)" header with a value like "(.*)"$/ do |header, regex|
  response.header[header].should =~ %r{#{regex}}
end

module HttpHelpers
  def make_request verb, path, table = nil
    params = {}
    if table
      table.hashes.each do |hash|
        params[hash['name']] = hash['value']
      end
    end

    cls = case verb.upcase
    when 'GET': :get
    when 'POST': :post
    when 'PUT': :put
    when 'DELETE': :delete
    else
      raise 'Verb must be GET, POST, PUT or DELETE'
    end

    visit path, cls, params
  end
  
end
World HttpHelpers
