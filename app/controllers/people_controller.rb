class PeopleController < ResourceController
  SERIALIZER_CLASS = 'PersonSerializer'.freeze
  POLICY_CLASS = 'PeoplePolicy'.freeze
  POLICY_SCOPE_CLASS = 'PeoplePolicy::Scope'.freeze

  # need to add includes etc to speed up query

  def serializer_includes
    [
      :bio,
      :base_tags
    ]
  end

  def includes
    serializer_includes
  end

  # def references
  #   [
  #   ]
  # end

  def allowed_params
    %i[
      lock_version
      comments
      organization
      job_title
      pronouns
      year_of_birth
      gender
      ethnicity
      opted_in
      invite_status
      acceptance_status
      registered
      registration_type
      can_share
      registration_number
      can_photo
      can_record
      name
      name_sort_by
      name_sort_by_confirmed
      pseudonym
      pseudonym_sort_by
      pseudonym_sort_by_confirmed
    ]
  end
  # TODO: these to be dealt with in seperate controllers ??
  # tags
  # :bio
end
