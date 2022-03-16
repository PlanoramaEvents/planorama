module AccessControlService
  def self.attribute_meta_data
    {
      # Need grouping for linked fields - by type and show all of them in the drop down
      # also size restrictions for short and long answers, need list
      # also social
      Person: {
        primary_email: { sensitive: true, linkable: false, type: :email},
        contact_email: { sensitive: true, linkable: true, type: :email},
        last_sign_in_at: { sensitive: true, linkable: false, type: :datetime},
        pronouns: { sensitive: true, linkable: true, type: :string},
        year_of_birth: { sensitive: true, linkable: false, type: :integer},
        gender: { sensitive: true, linkable: true, type: :string},
        ethnicity: { sensitive: true, linkable: true, type: :string},
        opted_in: { sensitive: true, linkable: false, type: :boolean},
        comments: { sensitive: true, linkable: false, type: :text},
        can_share: { sensitive: true, linkable: true, type: :boolean, values: [true, false]},
        invite_status: { sensitive: true, linkable: false, type: :enum},
        acceptance_status: { sensitive: true, linkable: false, type: :enum},
        registered: { sensitive: true, linkable: false, type: :boolean},
        registration_type: { sensitive: true, linkable: false, type: :string},
        registration_number: { sensitive: true, linkable: false, type: :string},
        bio: { sensitive: true, linkable: true, type: :text},
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
        awards: { sensitive: true, linkable: true, type: :text},
        needs_accommodations: { sensitive: true, linkable: true, type: :boolean, values: [true, false]},
        accommodations: { sensitive: true, linkable: true, type: :text},
        willing_to_moderate: { sensitive: true, linkable: true, type: :boolean, values: [true, false]},
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
        is_local: { sensitive: true, linkable: true, type: :boolean, values: [true, false]},
        langauges_fluent_in: { sensitive: true, linkable: true, type: :string},
        socialmedia: { sensitive: false, linkable: true, type: :socialmedia}
      }
    }
  end

  # TODO: add rbac check with DB
end
