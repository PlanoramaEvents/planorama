# == Schema Information
#
# Table name: surveys
#
#  id                        :uuid             not null, primary key
#  allow_submission_edits    :boolean          default(TRUE)
#  authenticate_msg          :text
#  branded                   :boolean          default(TRUE)
#  declined_msg              :text
#  description               :text
#  lock_version              :integer          default(0)
#  mandatory_star            :boolean          default(TRUE)
#  name                      :string
#  numbered_questions        :boolean          default(FALSE)
#  public                    :boolean
#  published_on              :datetime
#  submit_string             :string           default("Save")
#  thank_you                 :text
#  transition_accept_status  :enum
#  transition_decline_status :enum
#  unassigned                :boolean          default(FALSE)
#  unique_submission         :boolean          default(TRUE)
#  use_captcha               :boolean          default(FALSE)
#  welcome                   :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  created_by_id             :uuid
#  published_by_id           :uuid
#  updated_by_id             :uuid
#
require 'rails_helper'

RSpec.describe Survey  do
    context "Survey factory" do
        it "creates a simple survey" do
            survey = create(:survey)
            expect(survey.name).not_to be_empty
            expect(survey.transition_accept_status).to eq nil
            expect(survey.transition_decline_status).to eq nil
            expect(survey.public).to eq nil
            expect(survey.unassigned).to be false
        end

        it "creates a public survey" do
            survey = create(:survey, public: true)
            expect(survey.public).to eq true
        end

        it "creates an unassigned survey" do
            survey = create(:survey, unassigned: true)
            expect(survey.unassigned).to eq true
        end

    end
end
