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
      name_sort_by
      name_sort_by_confirmed
      pseudonym
      pseudonym_sort_by
      pseudonym_sort_by_confirmed
      published_name
      published_name_sort_by
    ]
  end
  # TODO: these to be dealt with in seperate controllers ??
  # tags
  # :bio
end
