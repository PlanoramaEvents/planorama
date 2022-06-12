require 'rails_helper'

RSpec.describe Session, "#factories" do
    context "session factory" do
        it "creates a session" do
            session = create(:session)
            expect(session.format).to be_truthy
            expect(session).to_not be_published
            expect(session.people).to be_empty
            expect(session.session_assignments).to be_empty
            expect(session.duration).to be(0)
            expect(session.minimum_people).to be_nil
            expect(session.maximum_people).to be_nil
        end
    end

    context "panel factory" do
        it "creates a panel" do
            panel = create(:panel)
            expect(panel.title).to eq "a panel"
            expect(panel.format.name).to include "panel"
        end
    end

    context "session_with_participants factory" do
        it "creates a session with participants" do
            item = create(:session_with_participants)
            expect(item.people.length).to eq 5
        end
    end
end
