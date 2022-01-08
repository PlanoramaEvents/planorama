require "rails_helper"

#
# Test the person end points ...
#
RSpec.describe 'Surveys', type: :request do
  before {
    sign_in_person
  }

  after {
    sign_out_person
  }

  describe 'Surveys' do
    it 'Gets list of surveys' do
      get "/survey?perPage=5"

      # puts "******* #{json}"
      expect(response).to have_http_status(200)
      expect(json).not_to be_empty
      expect(json['meta']['total']).to be > 0
    end
  end
end
