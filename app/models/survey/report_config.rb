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
#  survey_id    :bigint           not null
#
# Indexes
#
#  index_survey_report_configs_on_survey_id  (survey_id)
#
class Survey::ReportConfig < ApplicationRecord
  # query - the where part of query for the report
  # LA is based on a multi-choice question so query is
  # 
  #  select survey_submissions.* from survey_submissions
  #  join survey_responses on survey_responses.submission_id = survey_submissions.id
  #  where
  #  survey_responses.response ->> 'answers' ilike '%e585afa5-df82-4499-8aef-64fc3bb7bac3%'
  # 
  # so we need to gen 
  #     where survey_responses.response ->> 'answers' ilike '%e585afa5-df82-4499-8aef-64fc3bb7bac3%'
  # Suggested jsonb
  # {
  #   field: 'survey_responses.response',
  #   op: 'ilike',
  #   value: '%e585afa5-df82-4499-8aef-64fc3bb7bac3%'
  # }
  # 
  # Question_id is a list of fields to include in the report
end
