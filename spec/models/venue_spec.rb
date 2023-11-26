# == Schema Information
#
# Table name: venues
#
#  id           :uuid             not null, primary key
#  address      :string
#  lock_version :integer          default(0)
#  name         :string
#  sort_order   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Venue, "#factories"  do
    context "venue factory" do
        it "creates a venue" do
            venue = create(:venue)
            expect(venue.name).to include("Hotel")
            expect(venue.sort_order).to eq 0
        end
    end

    context "venue_with_sort_order factory" do
        it "creates a venue with sort order" do
            venue = create(:venue_with_sort_order)
            expect(venue.sort_order).to be_an(Integer)
        end
    end
end
