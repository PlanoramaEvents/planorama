require "rails_helper"

#
# Test the person end points ...
#
RSpec.describe 'People', type: :request do
  before {
    sign_in_person
  }

  after {
    sign_out_person
  }

  describe 'People' do
    it 'List people' do
      get '/person?perPage=10'

      expect(response).to have_http_status(200)
      expect(json).not_to be_empty
      expect(json['data'].size).to be == 10
      expect(json['meta']['total']).to be > 10
    end

    it 'Find a person' do
      p = Person.first
      get "/person/#{p.id}"

      expect(json).not_to be_empty
      expect(json['data']['id']).to be == p.id.to_s
      expect(response).to have_http_status(200)
    end

    it 'Create a new person' do
      name = Faker::Name.name
      email = "#{name.gsub(' ', '_')}@test.com"

      post "/person",
        params: {
          person: {
            name: name,
            name_sort_by: name,
            name_sort_by_confirmed: true,
            email_addresses_attributes: [
              {
                isdefault: true,
                email: email,
                is_valid: true
              }
            ]
          }
        }

      expect(response).to have_http_status(200)

      p = Person.find_by name: name
      expect(json['data']['id']).to be == p.id.to_s
      expect(json['data']['attributes']['name']).to be == p.name

      email_id = json['data']['relationships']['email_addresses']['data'].first['id']
      expect(email_id).to be_a_kind_of(String)

      result_email = json['included'].find{|a| a['id'] == email_id }
      expect(result_email['type']).to be == 'email_address'
      expect(result_email['attributes']['email']).to be == email
    end

    it 'The me session' do
      p = Person.find_by name: 'test'
      get "/person/me"

      expect(json).not_to be_empty
      expect(json['data']['type']).to be == 'session'
      expect(json['data']['id']).to be == p.id.to_s
      expect(response).to have_http_status(200)
    end

    it 'Delete a person' do
      name = Faker::Name.name
      p = Person.create(name: name)
      id = p.id
      delete "/person/#{id}"
      p = Person.find_by name: name
      expect(p).to be nil
      expect(response).to have_http_status(200)
    end

    it 'Create a new person - no DB save' do
      get "/person/new"
      expect(json['data']['id']).not_to be(nil)
      expect(response).to have_http_status(200)
    end
  end
end
