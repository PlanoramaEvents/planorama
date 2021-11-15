require "rails_helper"

#
# Test the person end points ...
#
RSpec.describe 'Survey Pages', type: :request do
  before {
    sign_in_person
  }

  after {
    sign_out_person
  }

  describe 'Survey Pages' do
    it 'Get a list of survey pages' do
      s = Survey.first
      get "/survey/#{s.id}/page?perPage=1"
      # puts "******* #{json}"
      expect(response).to have_http_status(200)
      expect(json).not_to be_empty
      expect(json['meta']['total']).to be > 0
    end

    it 'Create survey page (deep method)' do
      s = Survey.first
      page_title = Faker::Books::CultureSeries.civ

      post "/survey/#{s.id}/page",
        params: {
          page: {
            title: page_title
          }
        }

      expect(response).to have_http_status(200)
      expect(json).not_to be_empty
    end

    it 'Create survey page (shallow method)' do
      s = Survey.first
      page_title = Faker::Books::CultureSeries.civ
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
          }

      expect(response).to have_http_status(200)
      expect(json).not_to be_empty
    end
  end
end
