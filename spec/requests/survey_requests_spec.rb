require "rails_helper"
require 'devise/jwt/test_helpers'

#
# Test the person end points ...
#
RSpec.describe 'Surveys', type: :request do
  describe 'GET surveys' do
    before { get "/survey?perPage=5", headers: auth_header }

    it 'returns surveys' do
      # puts "******* #{json}"
      expect(json).not_to be_empty
      expect(json['meta']['total']).to be > 0
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
