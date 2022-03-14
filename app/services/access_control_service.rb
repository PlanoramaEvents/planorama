module AccessControlService
  def self.attribute_meta_data
    # attribute, sensitive, linkable, type, values
    {
      Person: {
        primary_email: { sensitive: true, linkable: false, type: :string},
        contact_email: { sensitive: true, linkable: true, type: :string},
        last_sign_in_at: { sensitive: true, linkable: true, type: :string},
        pronouns: { sensitive: true, linkable: true, type: :string},
        year_of_birth: { sensitive: true, linkable: true, type: :string},
        gender: { sensitive: true, linkable: true, type: :string},
        ethnicity: { sensitive: true, linkable: true, type: :string},
        opted_in: { sensitive: true, linkable: true, type: :string},
        comments: { sensitive: true, linkable: true, type: :string},
        can_share: { sensitive: true, linkable: true, type: :string},
        invite_status: { sensitive: true, linkable: true, type: :string},
        acceptance_status: { sensitive: true, linkable: true, type: :string},
        registered: { sensitive: true, linkable: true, type: :string},
        registration_type: { sensitive: true, linkable: true, type: :string},
        registration_number: { sensitive: true, linkable: true, type: :string},
        bio: { sensitive: true, linkable: true, type: :string},
        website: { sensitive: true, linkable: true, type: :string},
        twitter: { sensitive: true, linkable: true, type: :string},
        othersocialmedia: { sensitive: true, linkable: true, type: :string},
        facebook: { sensitive: true, linkable: true, type: :string},
        linkedin: { sensitive: true, linkable: true, type: :string},
        twitch: { sensitive: true, linkable: true, type: :string},
        youtube: { sensitive: true, linkable: true, type: :string},
        instagram: { sensitive: true, linkable: true, type: :string},
        flickr: { sensitive: true, linkable: true, type: :string},
        reddit: { sensitive: true, linkable: true, type: :string},
        tiktok: { sensitive: true, linkable: true, type: :string},
        can_stream: { sensitive: true, linkable: true, type: :yesnomaybe, values: ['yes', 'no', 'maybe']},
        can_record: { sensitive: true, linkable: true, type: :yesnomaybe, values: ['yes', 'no', 'maybe']},
        can_photo: { sensitive: true, linkable: true, type: :yesnomaybe, values: ['yes', 'no', 'maybe']},
        age_at_convention: { sensitive: true, linkable: true, type: :string},
        romantic_sexual_orientation: { sensitive: true, linkable: true, type: :string},
        awards: { sensitive: true, linkable: true, type: :string},
        needs_accommodations: { sensitive: true, linkable: true, type: :boolean, values: [true, false]},
        accommodations: { sensitive: true, linkable: true, type: :string},
        willing_to_moderate: { sensitive: true, linkable: true, type: :boolean, values: [true, false]},
        moderation_experience: { sensitive: true, linkable: true, type: :string},
        othered: { sensitive: true, linkable: true, type: :string},
        indigenous: { sensitive: true, linkable: true, type: :string},
        black_diaspora: { sensitive: true, linkable: true, type: :string},
        non_us_centric_perspectives: { sensitive: true, linkable: true, type: :string},
        demographic_categories: { sensitive: true, linkable: true, type: :string},
        do_not_assign_with: { sensitive: true, linkable: true, type: :string},
        can_stream_exceptions: { sensitive: true, linkable: true, type: :string},
        can_record_exceptions: { sensitive: true, linkable: true, type: :string},
        can_photo_exceptions: { sensitive: true, linkable: true, type: :string},
        is_local: { sensitive: true, linkable: true, type: :boolean, values: [true, false]},
        langauges_fluent_in: { sensitive: true, linkable: true, type: :string}
      }
    }
  end

  # TODO: add rbac check with DB
end
