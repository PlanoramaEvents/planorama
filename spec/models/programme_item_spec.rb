require 'rails_helper'

RSpec.describe ProgrammeItem, "#factories" do
    context "programme_item factory" do
        it "creates a programme item" do
            programme_item = create(:programme_item)
            expect(programme_item.format).to be_truthy
            expect(programme_item.setup_type).to be_truthy
            expect(programme_item).to_not be_published
            expect(programme_item.people).to be_empty
            expect(programme_item.programme_assignments).to be_empty
            expect(programme_item.duration).to be_nil
            expect(programme_item.minimum_people).to be_nil
            expect(programme_item.maximum_people).to be_nil
        end
    end

    context "panel factory" do
        it "creates a panel" do
            panel = create(:panel)
            expect(panel.title).to eq "a panel"
            expect(panel.format.name).to include "panel"
        end
    end

    context "programme_item_with_participants factory" do
        it "creates a programme item with participants" do
            item = create(:programme_item_with_participants)
            expect(item.people.length).to eq 5
        end
    end
end
