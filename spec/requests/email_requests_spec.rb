require "rails_helper"
require 'devise/jwt/test_helpers'

#
# Test the person end points ...
#
RSpec.describe 'EmailAddresses', type: :request do
  describe 'GET emails' do
    p = Person.first
    before { get "/person/#{p.id}/email_address", headers: auth_header }

    it 'returns emails' do
      expect(json).not_to be_empty
      expect(json['meta']['total']).to be > 0
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'Create a new email for a person' do
    p = Person.first
    new_email = 'email+test@test.com'
    before {
      post "/person/#{p.id}/email_address",
        params: {
          isdefault: false,
          email: new_email,
          is_valid: true
        }.to_json,
        headers: auth_header
    }

    it 'returns status code 200' do
      # puts "***** #{json}"
      expect(json['data']['type']).to be == 'email_address'
      expect(json['data']['attributes']['email']).to be == new_email
      expect(response).to have_http_status(200)
    end
  end

end
