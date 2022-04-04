module Audit
  class PublishedSessionVersion < PaperTrail::Version
    self.table_name = :audit_published_session_versions
  end
end
