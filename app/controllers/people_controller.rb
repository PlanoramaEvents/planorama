class PeopleController < ResourceController
  SERIALIZER_CLASS = 'PersonSerializer'.freeze

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
      pseudonym
      sort_by
      sort_by_confirmed
    ]
  end
  # TODO: these to be dealt with in seperate controllers ??
  # tags
  # :bio
end
