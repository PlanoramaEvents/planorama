class PersonSerializer < ActiveModel::Serializer
  attributes :id, :lock_version,
             :prefix, :first_name, :last_name, :suffix,
             :pseudonym_prefix, :pseudonym_first_name,
             :pseudonym_last_name, :pseudonym_suffix,
             :published_name, :published_last_name,
             :job_title, :organization,
             :pronouns, :year_of_birth, :gender, :ethnicity,
             :opted_in, :comments,
             :can_share, :can_photo, :can_record,
             :invite_status, :acceptance_status,
             :registered, :registration_type, :registration_number

  has_one :bio

  # tag_list
  attribute :tags do
    object.base_tags.collect(&:name)
  end
end
