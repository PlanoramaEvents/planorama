# == Schema Information
#
# Table name: person_exclusions
#
#  id           :uuid             not null, primary key
#  lock_version :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  exclusion_id :uuid
#  person_id    :uuid
#
# Indexes
#
#  index_person_exclusions_on_person_id                   (person_id)
#  index_person_exclusions_on_person_id_and_exclusion_id  (person_id,exclusion_id) UNIQUE
#
class PersonExclusionSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :person_id, :exclusion_id
end
