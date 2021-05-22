require 'rails_helper'

RSpec.describe Survey  do
    context "Survey factory" do
        it "creates a simple survey" do
            survey = create(:survey)
            expect(survey.name).not_to be_empty
            expect(survey.transition_accept_status).to eq nil
            expect(survey.transition_decline_status).to eq nil
            expect(survey.public).to eq nil
            expect(survey.authenticate).to eq nil
            expect(survey.anonymous).to be false
        end

        it "creates a public survey" do
            survey = create(:survey, public: true)
            expect(survey.public).to eq true
        end

        it "creates an anonymous survey" do
            survey = create(:survey, anonymous: true)
            expect(survey.anonymous).to eq true
        end

    end
end
