require "rails_helper"
require 'uri'

#
# Test the person end points ...
#
RSpec.describe 'Page Contents', type: :request do
  before {
    create_list(:page_content, 10)
    sign_in_person
  }

  after {
    sign_out_person
  }

  describe 'Page Contents' do
    it 'Gets list of page content' do
      # create_list(:page_content, 10)
      get "/page_content"

      # puts "******* #{json}"
      expect(response).to have_http_status(200)
      expect(json).not_to be_empty
    end
  end

  # We want to get an individual page by name
  # a filter would do but ...
  describe 'Get page 1' do
    it 'Gets list of page content' do
      # create_list(:page_content, 10)
      # get "/page_content"
      params = URI.encode_uri_component 'filter={"op":"all","queries":[["name", "=", "page 1"]]}'

      get "/page_content?#{params}"
      # puts "******* #{json}"
      expect(response).to have_http_status(200)
      expect(json).not_to be_empty
    end
  end
end
