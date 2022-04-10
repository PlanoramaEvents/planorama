module AccessControlService
  # Return meta information on sensitive attributes
  # at the moment this is a pre-determined structure
  def self.attribute_meta_data
    {
      # Need grouping for linked fields - by type and show all of them in the drop down
      # also size restrictions for short and long answers, need list
      # also social
      Person: {
        primary_email: { sensitive: true, linkable: false, type: :email},
        contact_email: { sensitive: true, linkable: true, type: :email},
        last_sign_in_at: { sensitive: true, linkable: false, type: :datetime},
        current_sign_in_at: { sensitive: true, linkable: false, type: :datetime},
        pronouns: { sensitive: true, linkable: true, type: :string},
        year_of_birth: { sensitive: true, linkable: false, type: :integer},
        gender: { sensitive: true, linkable: true, type: :string},
        ethnicity: { sensitive: true, linkable: true, type: :string},
        opted_in: { sensitive: true, linkable: false, type: :boolean},
        comments: { sensitive: true, linkable: false, type: :text},
        can_share: { sensitive: true, linkable: true, type: :boolean, values: [true, false]}, # PROB???
        con_state: { sensitive: true, linkable: false, type: :enum},
        registered: { sensitive: false, linkable: false, type: :boolean},
        registration_type: { sensitive: true, linkable: false, type: :string},
        registration_number: { sensitive: true, linkable: false, type: :string},
        attendance_type: { sensitive: false, linkable: true, type: :attendance_type, values: ['in person', 'virtual', 'hybrid']},
        bio: { sensitive: true, linkable: true, type: :text},
        website: { sensitive: false, linkable: true, type: :string},
        twitter: { sensitive: false, linkable: true, type: :string},
        othersocialmedia: { sensitive: false, linkable: true, type: :string},
        facebook: { sensitive: false, linkable: true, type: :string},
        linkedin: { sensitive: false, linkable: true, type: :string},
        twitch: { sensitive: false, linkable: true, type: :string},
        youtube: { sensitive: false, linkable: true, type: :string},
        instagram: { sensitive: false, linkable: true, type: :string},
        flickr: { sensitive: false, linkable: true, type: :string},
        reddit: { sensitive: false, linkable: true, type: :string},
        tiktok: { sensitive: false, linkable: true, type: :string},
        can_stream: { sensitive: true, linkable: true, type: :yesnomaybe, values: ['yes', 'no', 'maybe']},
        can_record: { sensitive: true, linkable: true, type: :yesnomaybe, values: ['yes', 'no', 'maybe']},
        can_photo: { sensitive: true, linkable: true, type: :yesnomaybe, values: ['yes', 'no', 'maybe']},
        age_at_convention: { sensitive: true, linkable: true, type: :string},
        romantic_sexual_orientation: { sensitive: true, linkable: true, type: :string},
        needs_accommodations: { sensitive: true, linkable: true, type: :boolean, values: [true, false]}, # PROB???
        accommodations: { sensitive: true, linkable: true, type: :text},
        willing_to_moderate: { sensitive: true, linkable: true, type: :boolean, values: [true, false]}, # PROB???
        moderation_experience: { sensitive: true, linkable: true, type: :text},
        othered: { sensitive: true, linkable: true, type: :text},
        indigenous: { sensitive: true, linkable: true, type: :text},
        black_diaspora: { sensitive: true, linkable: true, type: :text},
        non_us_centric_perspectives: { sensitive: true, linkable: true, type: :text},
        demographic_categories: { sensitive: true, linkable: true, type: :text},
        do_not_assign_with: { sensitive: true, linkable: true, type: :text},
        can_stream_exceptions: { sensitive: true, linkable: true, type: :text},
        can_record_exceptions: { sensitive: true, linkable: true, type: :text},
        can_photo_exceptions: { sensitive: true, linkable: true, type: :text},
        is_local: { sensitive: true, linkable: true, type: :boolean, values: [true, false]}, # PROB???
        languages_fluent_in: { sensitive: true, linkable: true, type: :string},
        socialmedia: { sensitive: false, linkable: true, type: :socialmedia}
      }
    }
  end

  # Return a list of sensitive attributes for the given model
  def self.sensitive_attributes(model:)
    return [] unless attribute_meta_data[model.to_sym]

    attribute_meta_data[model.to_sym].filter{|k,v| v[:sensitive]}.keys
  end

  # Return a list of linkable attributes for the given model
  def self.linkable_attributes(model:)
    attribute_meta_data[model.to_sym].filter{|k,v| v[:linkable]}.keys
  end

  # Return whether the person is allowed access to any sensitive attributes
  def self.allowed_sensitive_access?(person:)
    return false unless person

    # TODO: add rbac check with DB, based on the role
    # Rails.logger.debug("******** ALLOWED FOR #{person}")

    # Get the role for the person
    # if that role allow access to sensitive info then true else false

    # NOTE: this is the hard-wired mechanism to limit sensitive information to
    # admins for now
    person.convention_roles.collect(&:role).include?('admin')
    # false
  end

  # Return a list of attributes that are not allowed for the person from this instance
  def self.banned_attributes(model:, instance: nil, person:)
    if instance && instance.is_a?(Person)
      return [] if instance.id == person.id
    end

    return [] if allowed_sensitive_access?(person: person)

    sensitive_attributes(model: model)
  end

  # Return true if the person is allowed access to the
  # the specific attribute of the given model
  def self.sensitive_access?(person:, model:, attribute:)
    # if the attribute is not sensitive then access is always allowed
    return true unless sensitive_attributes(model: model).include? attribute

    # check if the person is allowed access to sensitive attributes
    allowed_sensitive_access?(person: person)
  end

  def self.linked_field_access?(linked_field:, person:)
    fields = linked_field.split('.',2)
    return true unless sensitive_attributes(model: fields[0]).include? fields[1].to_sym

    allowed_sensitive_access?(person: person)

    false
  end

  # Return true if the person is allowed access to the
  # sensitive attributes of this instance
  def self.allowed_access?(instance:, person: nil)
    # Rails.logger.debug("******** ALLOWED ACCESS FOR #{instance} - #{person}")
    # if the instance is a person and the requesting person
    # is the same then they are allowed access
    if instance.is_a?(Person) && person
      return true if instance.id == person.id
    end

    # test to see if person is allowed access to sensitive info
    allowed_sensitive_access?(person: person)
  end

  # Return true if the person is allowed access to the specific attribute
  # of the instance
  def self.allowed_attribute_access?(instance:, attributes:, person:)
    # if the instance is a person and the requesting person
    # is the same then they are allowed access
    if instance.is_a?(Person)
      return true if instance.id == person.id
    end

    res = true
    attributes.each do |attr|
      res = res && sensitive_access?(
                      person: person,
                      model: instance.class.name,
                      attribute: attr
                    )
    end

    res
  end
end
