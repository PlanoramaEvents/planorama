# == Schema Information
#
# Table name: survey_report_configs
#
#  id           :uuid             not null, primary key
#  description  :text
#  lock_version :integer
#  name         :string(100)
#  query        :jsonb            not null
#  question_ids :uuid             is an Array
#  sort_order   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  survey_id    :uuid             not null
#
# Indexes
#
#  index_survey_report_configs_on_survey_id  (survey_id)
#
# Foreign Keys
#
#  fk_rails_...  (survey_id => surveys.id)
#
class Survey::ReportConfig < ApplicationRecord
  belongs_to :survey
end
