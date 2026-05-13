# == Schema Information
#
# Table name: survey_report_configs
#
#  id           :uuid             not null, primary key
#  description  :text
#  lock_version :integer
#  name         :string(100)
#  query        :jsonb            not null
#  questions    :jsonb            is an Array
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
class Survey::ReportConfigSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version,
             :sort_order, :created_at, :updated_at,
             :name, :description, :questions, :survey_id

end
