module RequestSpecHelper
  include Warden::Test::Helpers

  # helper to get the JSON structure from the response body
  def json
    JSON.parse(response.body)
  end

  def sign_in_person(name: nil)
    name ||= 'test'
    person = Person.find_by name: name

    sign_in person
  end

  def sign_out_person(name: nil)
    name ||= 'test'
    person = Person.find_by name: name

    sign_out person
  end
end
