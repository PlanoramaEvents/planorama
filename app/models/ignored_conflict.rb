# == Schema Information
#
# Table name: ignored_conflicts
#
#  id            :uuid             not null, primary key
#  conflict_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  conflict_id   :string(2048)
#
# Indexes
#
#  index_ignored_conflicts_on_conflict_id_and_conflict_type  (conflict_id,conflict_type) UNIQUE
#
class IgnoredConflict < ApplicationRecord
end
