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
      expect(json['data']['id'].to_i).to be == p.id
    end
  end
end
