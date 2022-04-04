module Audit
  class PersonVersion < PaperTrail::Version
    self.table_name = :audit_people_versions
  end
end
