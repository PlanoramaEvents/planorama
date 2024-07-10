module AccessControlService
  # Return meta information on sensitive attributes
  # at the moment this is a pre-determined structure
  def self.attribute_meta_data
    {
      # Need grouping for linked fields - by type and show all of them in the drop down
      # also size restrictions for short and long answers, need list
      # also social
      Person: {
        name: { sensitive: false, linkable: true, type: :string, hidable: false},
        pseudonym: { sensitive: false, linkable: true, type: :string, hidable: false},
        primary_email: { sensitive: false, linkable: false, type: :email, hidable: false},
        contact_email: { sensitive: false, linkable: false, type: :email, hidable: false},
        last_sign_in_at: { sensitive: false, linkable: false, type: :datetime, hidable: false},
        current_sign_in_at: { sensitive: false, linkable: false, type: :datetime, hidable: false},
        pronouns: { sensitive: false, linkable: true, type: :string, hidable: false},
        year_of_birth: { sensitive: true, linkable: false, type: :integer, hidable: false},
        gender: { sensitive: true, linkable: true, type: :string, hidable: false},
        ethnicity: { sensitive: true, linkable: true, type: :string, hidable: false},
        opted_in: { sensitive: true, linkable: false, type: :boolean, hidable: false},
        comments: { sensitive: false, linkable: false, type: :text, hidable: false},
        can_share: { sensitive: false, linkable: true, type: :boolean, values: [true, false], hidable: false},
        con_state: { sensitive: false, linkable: false, type: :enum, hidable: false},
        registered: { sensitive: false, linkable: false, type: :boolean, hidable: false},
        registration_type: { sensitive: true, linkable: false, type: :string, hidable: false},
        registration_number: { sensitive: true, linkable: false, type: :string, hidable: false},
        attendance_type: { sensitive: false, linkable: true, type: :attendance_type, values: ['in_person', 'virtual', 'hybrid'], hidable: false},
        bio: { sensitive: false, linkable: true, type: :text, hidable: false},
        # NOTE: we really do not want individual social media fields to be linked,
        # this was done as the google form migration. Surveys in Plano should use
        # the social media question type
        website: { sensitive: false, linkable: false, type: :string, hidable: false},
        twitter: { sensitive: false, linkable: false, type: :string, hidable: false},
        fediverse: { sensitive: false, linkable: false, type: :string, hidable: false},
        bsky: { sensitive: false, linkable: false, type: :string, hidable: false},
        othersocialmedia: { sensitive: false, linkable: false, type: :string, hidable: false},
        facebook: { sensitive: false, linkable: false, type: :string, hidable: false},
        linkedin: { sensitive: false, linkable: false, type: :string, hidable: false},
        twitch: { sensitive: false, linkable: false, type: :string, hidable: false},
        youtube: { sensitive: false, linkable: false, type: :string, hidable: false},
        instagram: { sensitive: false, linkable: false, type: :string, hidable: false},
        flickr: { sensitive: false, linkable: false, type: :string, hidable: false},
        reddit: { sensitive: false, linkable: false, type: :string, hidable: false},
        tiktok: { sensitive: false, linkable: false, type: :string, hidable: false},
        can_stream: { sensitive: false, linkable: true, type: :yesnomaybe, values: ['yes', 'no', 'maybe'], hidable: false},
        can_record: { sensitive: false, linkable: true, type: :yesnomaybe, values: ['yes', 'no', 'maybe'], hidable: false},
        can_photo: { sensitive: false, linkable: true, type: :yesnomaybe, values: ['yes', 'no', 'maybe'], hidable: false},
        age_at_convention: { sensitive: true, linkable: true, type: :string, hidable: false},
        romantic_sexual_orientation: { sensitive: true, linkable: true, type: :string, hidable: false},
        needs_accommodations: { sensitive: true, linkable: true, type: :boolean, values: [true, false], hidable: false},
        accommodations: { sensitive: true, linkable: true, type: :text, hidable: false},
        willing_to_moderate: { sensitive: false, linkable: true, type: :boolean, values: [true, false], hidable: false},
        moderation_experience: { sensitive: false, linkable: true, type: :text, hidable: false},
        othered: { sensitive: true, linkable: true, type: :text, hidable: true},
        indigenous: { sensitive: true, linkable: true, type: :text, hidable: true},
        black_diaspora: { sensitive: true, linkable: true, type: :text, hidable: true},
        non_us_centric_perspectives: { sensitive: true, linkable: true, type: :text, hidable: true},
        demographic_categories: { sensitive: true, linkable: true, type: :text, hidable: true},
        excluded_demographic_categories: { sensitive: true, linkable: true, type: :text, hidable: true},
        global_diaspora: { sensitive: true, linkable: true, type: :text, hidable: true},
        non_anglophone: { sensitive: true, linkable: true, type: :text, hidable: true},
        do_not_assign_with: { sensitive: true, linkable: true, type: :text, hidable: false},
        can_stream_exceptions: { sensitive: false, linkable: true, type: :text, hidable: false},
        can_record_exceptions: { sensitive: false, linkable: true, type: :text, hidable: false},
        can_photo_exceptions: { sensitive: false, linkable: false, type: :text, hidable: false},
        is_local: { sensitive: false, linkable: true, type: :boolean, values: [true, false], hidable: false},
        languages_fluent_in: { sensitive: false, linkable: true, type: :string, hidable: false},
        socialmedia: { sensitive: false, linkable: true, type: :socialmedia, hidable: false}
      }
    }
  end

  #
  def self.can_execute?(model: , action: , person:)
    # If the person is an admin then no need to check roles
    return true if person.convention_roles.collect(&:role).include?('admin')

    policies = PolicyService.policies_for(person: person)
    model_policy = policies[model.downcase]
    action_perm = model_policy[action.to_s] if model_policy

    return action_perm ? action_perm : false
  end

  # Return a list of sensitive attributes for the given model
  def self.sensitive_attributes(model:)
    return RequestStore.store["sensitive_attributes_store"] if RequestStore.store["sensitive_attributes_store"]

    RequestStore.store["sensitive_attributes_store"] = []
    return [] unless attribute_meta_data[model.to_sym]

    res = attribute_meta_data[model.to_sym].filter{|k,v| v[:sensitive]}.keys
    RequestStore.store["sensitive_attributes_store"] = res

    res
  end

  # Return a list of linkable attributes for the given model
  def self.linkable_attributes(model:)
    attribute_meta_data[model.to_sym].filter{|k,v| v[:linkable]}.keys
  end

  # Return whether the person is allowed access to any sensitive attributes
  def self.allowed_sensitive_access?(person:)
    return false unless person

    # This is the hard-wired mechanism to limit sensitive information to admins for now
    return true if person.convention_roles.collect(&:role).include?('admin')

    # Use rbac of the person is not an admin
    policies = PolicyService.policies_for(person: person)
    return policies[:sensitive_access]
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

  def self.shared_attribute_access?(instance:, person:)
    return true if person.convention_roles.collect(&:role).include?('admin')

    if instance.is_a?(Person)
      return true if instance.id == person.id

      return true if instance.can_share
    end

    return false if person.convention_roles.count == 0
    return false if (person.convention_roles.count == 1) && person.convention_roles.collect(&:role).include?('participant')

    true
  end
end
