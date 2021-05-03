require 'rails_helper'

RSpec.describe Room, "#factories"  do
    context "room factory" do
        it "creates a room" do
            room = create(:room)
            expect(room.name).to include("my room")
            expect(room.purpose).to be_nil
            expect(room.comment).to be_nil
            expect(room.sort_order).to eq 0
            expect(room.capacity).to be_nil
        end
    end

    context "room_with_detail factory" do
        it "creates a room with details" do
            room = create(:room_with_detail)
            expect(room.purpose).to_not be_empty
            expect(room.comment).to_not be_empty
            expect(room.sort_order).to be_an(Integer)
            expect(room.capacity).to be_an(Integer)
        end
    end
end
