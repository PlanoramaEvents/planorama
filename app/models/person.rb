## schema
# CREATE TABLE public.people (
#     id integer NOT NULL,
#     language character varying(5) DEFAULT ''::character varying,
#     created_at timestamp without time zone NOT NULL,
#     updated_at timestamp without time zone NOT NULL,
#     lock_version integer DEFAULT 0,
#     comments text,
#     organization character varying,
#     job_title character varying,
#     pronouns character varying(100),
#     year_of_birth integer,
#     gender character varying(100),
#     ethnicity character varying(100),
#     opted_in boolean DEFAULT false NOT NULL,
#     invite_status public.invite_status_enum DEFAULT 'not_set'::public.invite_status_enum,
#     acceptance_status public.acceptance_status_enum DEFAULT 'unknown'::public.acceptance_status_enum,
#     registered boolean DEFAULT false NOT NULL,
#     registration_type character varying,
#     can_share boolean DEFAULT false NOT NULL,
#     registration_number character varying,
#     can_photo boolean DEFAULT false NOT NULL,
#     can_record boolean DEFAULT false,
#     encrypted_password character varying DEFAULT ''::character varying NOT NULL,
#     reset_password_token character varying,
#     reset_password_sent_at timestamp without time zone,
#     remember_created_at timestamp without time zone
#     sign_in_count integer DEFAULT 0 NOT NULL,
#     current_sign_in_at timestamp without time zone,
#     last_sign_in_at timestamp without time zone,
#     current_sign_in_ip inet,
#     last_sign_in_ip inet,
#     confirmation_token character varying,
#     confirmed_at timestamp without time zone,
#     confirmation_sent_at timestamp without time zone,
#     unconfirmed_email character varying,
#     failed_attempts integer DEFAULT 0 NOT NULL,
#     unlock_token character varying,
#     locked_at timestamp without time zone,
#     name character
# );

class Person < ApplicationRecord
  # Include default devise modules. Others available are:
  devise :database_authenticatable,
         :timeoutable,
         :rememberable,
         :registerable,
         :recoverable,
         :validatable, :lockable, :trackable

  # TODO: add a deleted_at mechanism

  # TODO: on save ensure that there is an email address !!!
  # perhaps in the controller ?

  #   so when i save it, it should be email_address_attributes
  # ugh which means i probably need to change allowed params
  # can you take care of that too?

  # acts_as_taggable
  acts_as_taggable_on :tags

  has_paper_trail

  before_destroy :check_if_assigned

  has_many  :session_assignments, dependent: :destroy
  has_many  :sessions, through: :session_assignments

  # We let the publish mechanism do the destroy so that the update service knows what is happening
  # has_many  :published_session_assignments
  # has_many  :published_sessions, through: :published_session_assignments

  has_many  :person_mailing_assignments
  has_many  :mailings, through: :person_mailing_assignments
  has_many  :mail_histories

  has_many  :email_addresses, dependent: :destroy
  accepts_nested_attributes_for :email_addresses, reject_if: :all_blank, allow_destroy: true

  has_one :primary_email,
          -> { where(['isdefault = true']) },
          class_name: 'EmailAddress'

  has_many :submissions, class_name: 'Survey::Submission', dependent: :destroy
  has_many :mailed_surveys, through: :mailings, source: :survey
  has_and_belongs_to_many :assigned_surveys, class_name: 'Survey'

  # TODO: get a list of surveys assigned AND those with submissions that are not assigned

  has_many :convention_roles, dependent: :destroy
  accepts_nested_attributes_for :convention_roles, allow_destroy: true

  has_many  :person_agreements
  has_many  :agreements, through: :person_agreements

  enum acceptance_status: {
    unknown: 'unknown',
    probable: 'probable',
    accepted: 'accepted',
    declined: 'declined'
  }

  enum invite_status: {
    not_set: 'not_set',
    do_not_invite: 'do_not_invite',
    potential_invite: 'potential_invite',
    invite_pending: 'invite_pending',
    invited: 'invited',
    volunteered: 'volunteered'
  }

  nilify_blanks only: [
    :bio,
    :pseudonym,
    :website,
    :twitter,
    :othersocialmedia,
    :facebook,
    :linkedin,
    :twitch,
    :youtube,
    :instagram,
    :flickr,
    :reddit,
    :tiktok
  ]

  enum can_stream: { yes: 'yes', no: 'no', maybe: 'maybe'}, _prefix: true
  enum can_record: { yes: 'yes', no: 'no', maybe: 'maybe'}, _prefix: true
  enum can_photo: { yes: 'yes', no: 'no', maybe: 'maybe'}, _prefix: true

  validates :name, presence: true

  # protected_attributes :last_sign_in_at, :primary_email,
  #               :pronouns, :year_of_birth, :gender, :ethnicity,
  #               :opted_in, :comments,
  #               :can_share,
  #               :invite_status, :acceptance_status,
  #               :registered, :registration_type, :registration_number,
  #               :bio, :website, :twitter, :othersocialmedia,
  #               :facebook, :linkedin, :twitch, :youtube,
  #               :instagram, :flickr, :reddit, :tiktok,
  #               :can_stream,
  #               :can_record,
  #               :can_photo,
  #               :age_at_convention,
  #               :romantic_sexual_orientation,
  #               :awards,
  #               :needs_accommodations,
  #               :accommodations,
  #               :willing_to_moderate,
  #               :moderation_experience,
  #               :othered,
  #               :indigenous,
  #               :black_diaspora,
  #               :non_us_centric_perspectives,
  #               :demographic_categories,
  #               :do_not_assign_with,
  #               :can_stream_exceptions,
  #               :can_record_exceptions,
  #               :can_photo_exceptions,
  #               :is_local,
  #               :langauges_fluent_in


  # TODO:
  # - there is talk about having a workflow, including whether a person
  #   is vetted as a session participant. They could be have declined but
  #   pass vetting and later change their mind. So we do not want to
  #   or need to re-vet...
  #
  def email
    email_addresses.first&.email
  end

  def admin?
    convention_roles.inject(false) { |res, role| res || role.admin? }
  end

  def staff?
    convention_roles.inject(false) { |res, role| res || role.staff? }
  end

  def participant?
    convention_roles.inject(false) { |res, role| res || role.participant? }
  end

  def no_group?
    convention_roles.size == 0
  end

  #
  # For devise login as a person
  #
  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end

  def saved_change_to_email?
    email_addresses.first&.saved_change_to_email?
  end

  # def primary_email
  #   # TODO: change to find the primary email
  #   email_addresses.first&.email
  #   # emails.primary || (emails.first if new_record?)
  # end

  # def self.find_for_database_authentication warden_condition
  #   Rails.logger.error "******** WARDEN AUTH #{warden_condition.to_json}"
  # end

# https://dispatch.moonfarmer.com/separate-email-address-table-with-devise-in-rails-62208a47d3b9
# mapping.to.find_for_database_authentication(authentication_hash)
  def self.find_first_by_auth_conditions(warden_conditions, opts={})
    conditions = warden_conditions.dup

    # If "email" is an attribute in the conditions,
    # remove it and save to variable
    if (email = conditions.delete(:email))
      # Search through users by condition and also by
      # users who have associations to the provided email
      where(conditions.to_h)
        .includes(:email_addresses)
        .where(email_addresses: { email: email })
        .first
    else
      # super(warden_conditions)
      # If "email" is not an attribute in the conditions,
      # just search for users by the conditions as normal
      where(conditions.to_h)
        .first
    end
  end

  # check that the person has not been assigned to program items, if they have then return an error and do not delete
  def check_if_assigned
    if (SessionAssignment.where(person_id: id).count > 0) ||
       (PublishedSessionAssignment.where(person_id: id).count > 0)
      raise 'Cannot delete an assigned person'
    end
  end

  def valid_password?(password)
    return true if password.blank?

    super
  end

  def password_required?
    new_record? ? false : super
  end
end
