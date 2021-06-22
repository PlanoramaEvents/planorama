class PeopleController < ResourceController
  SERIALIZER_CLASS = 'PersonSerializer'.freeze
  POLICY_CLASS = 'PeoplePolicy'.freeze
  POLICY_SCOPE_CLASS = 'PeoplePolicy::Scope'.freeze

  # need to add includes etc to speed up query

  def includes
    [
      :bio,
      :base_tags
    ]
  end

  # def references
  #   [
  #   ]
  # end

  def allowed_params
    %i[
      lock_version
      first_name
      last_name
      prefix
      suffix
      comments
      organization
      job_title
      pseudonym_first_name
      pseudonym_last_name
      pseudonym_suffix
      pseudonym_prefix
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
    ]
  end
  # TODO: these to be dealt with in seperate controllers ??
  # tags
  # :bio
end
