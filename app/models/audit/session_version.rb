module Audit
  class SessionVersion < PaperTrail::Version
    self.table_name = :audit_session_versions
  end
end
