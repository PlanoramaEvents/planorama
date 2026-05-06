class Survey::ReportConfigSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version,
             :sort_order, :created_at, :updated_at,
             :name, :description, :question_ids, :survey_id

end
