require "rails_helper"

#
# Test the person end points ...
#
RSpec.describe 'EmailAddresses', type: :request do
  before {
    sign_in_person
  }

  after {
    sign_out_person
  }

  describe 'Emails' do
    it 'List email addresses' do
      p = Person.first
      get "/person/#{p.id}/email_address"

      expect(json).not_to be_empty
      expect(json['meta']['total']).to be > 0
      expect(response).to have_http_status(200)
    end

    it 'Created a new email for a person' do
      p = Person.first
      new_email = 'email+test@test.com'
      post "/person/#{p.id}/email_address",
            params: {
              email_address: {
                isdefault: false,
                email: new_email,
                is_valid: true
              }
            }

      expect(response).to have_http_status(200)
      expect(json['data']['type']).to be == 'email_address'
      expect(json['data']['attributes']['email']).to be == new_email
    end
  end

end
