module RequestSpecHelper
  # helper to get the JSON structure from the response body
  def json
    JSON.parse(response.body)
  end

  # helper to get the JWT header for a user with the given name
  def auth_header(name: nil)
    name ||= 'test' # if no name then we use the test user (which is an admin person)
    person = Person.find_by name: name
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, person)
  end
end
