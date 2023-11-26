# == Schema Information
#
# Table name: audit_people_versions
#
#  id             :bigint           not null, primary key
#  event          :string           not null
#  item_type      :string           not null
#  object         :json
#  object_changes :json
#  whodunnit      :string
#  created_at     :datetime
#  item_id        :uuid             not null
#
# Indexes
#
#  index_audit_people_versions_on_item_type_and_item_id  (item_type,item_id)
#
module Audit
  class PersonVersion < PaperTrail::Version
    self.table_name = :audit_people_versions
  end
end
