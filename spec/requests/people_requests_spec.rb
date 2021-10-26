require "rails_helper"
require 'devise/jwt/test_helpers'

#
# Test the person end points ...
#
RSpec.describe 'People', type: :request do

  describe 'GET people' do
    before { get '/person?perPage=10', headers: auth_header }

    it 'returns people' do
      expect(json).not_to be_empty
      expect(json['data'].size).to be == 10
      expect(json['meta']['total']).to be > 10
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET person' do
    p = Person.first
    before { get "/person/#{p.id}", headers: auth_header }

    it 'return a person' do
      expect(json).not_to be_empty
    end
    it 'return a person with correct id' do
      expect(json['data']['id']).to be == p.id.to_s
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'Create a new person' do
    name = Faker::Name.name
    email = "#{name.gsub(' ', '_')}@test.com"
    before {
      post "/person",
        params: {
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
        }.to_json,
        headers: auth_header
    }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
    it 'person was created in the db' do
      p = Person.find_by name: name
      expect(json['data']['id']).to be == p.id.to_s
    end
    it 'created person has the same name' do
      p = Person.find_by name: name
      expect(json['data']['attributes']['name']).to be == p.name
    end
    it 'created person has the same email' do
      p = Person.find_by name: name
      email_id = json['data']['relationships']['email_addresses']['data'].first['id']
      expect(email_id).to be_a_kind_of(String)
      result_email = json['included'].find{|a| a['id'] == email_id }
      expect(result_email['type']).to be == 'email_address'
      expect(result_email['attributes']['email']).to be == email
    end
  end

  describe 'GET the me session' do
    p = Person.find_by name: 'test'
    before { get "/person/me", headers: auth_header(name: 'test') }

    it 'return a session' do
      expect(json).not_to be_empty
      expect(json['data']['type']).to be == 'session'
    end
    it 'return a session with correct person id' do
      expect(json['data']['id']).to be == p.id.to_s
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'Delete a person' do
    name = Faker::Name.name
    p = Person.create(name: name)
    id = p.id
    before { delete "/person/#{id}", headers: auth_header(name: 'test') }

    it 'check that the person is deleted' do
      p = Person.find_by name: name
      expect(p).to be nil
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Update
end
