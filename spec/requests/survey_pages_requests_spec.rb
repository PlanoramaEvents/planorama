require "rails_helper"
require 'devise/jwt/test_helpers'

#
# Test the person end points ...
#
RSpec.describe 'Survey Pages', type: :request do
  describe 'GET survey pages' do
    s = Survey.first
    before { get "/survey/#{s.id}/page?perPage=1", headers: auth_header }

    it 'returns pages' do
      # puts "******* #{json}"
      expect(json).not_to be_empty
      expect(json['meta']['total']).to be > 0
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Using the URL to specifiy the survey
  describe 'Create survey page (deep method)' do
    s = Survey.first
    page_title = Faker::Books::CultureSeries.civ
    before {
      post "/survey/#{s.id}/page",
      params: {
        title: page_title
      }.to_json,
      headers: auth_header
    }

    it 'returns created page' do
      # puts "******* #{json}"
      expect(json).not_to be_empty
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Using the relationship to specify the survey
  describe 'Create survey page (shallow method)' do
    s = Survey.first
    page_title = Faker::Books::CultureSeries.civ
    before {
      post "/page",
      params:
        {
          "data": {
            "type": "page",
            "attributes": {
              title: page_title
            },
            "relationships": {
              "survey": {
                "data": { "type": "survey", "id": "#{s.id}" }
              }
            }
          }
        }.to_json,
      headers: auth_header
    }

    it 'returns created page' do
      # puts "******* #{json}"
      expect(json).not_to be_empty
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
