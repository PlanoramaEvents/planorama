module Audit
  class SurveyVersion < PaperTrail::Version
    self.table_name = :audit_survey_versions
  end
end
