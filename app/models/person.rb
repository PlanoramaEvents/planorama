# == Schema Information
#
# Table name: people
#
#  id                              :uuid             not null, primary key
#  accommodations                  :string(10000)
#  age_at_convention               :string
#  attendance_type                 :string(200)
#  availability_notes              :string
#  bio                             :text
#  black_diaspora                  :string(10000)
#  bsky                            :string
#  can_photo                       :enum             default("no")
#  can_photo_exceptions            :string(10000)
#  can_record                      :enum             default("no")
#  can_record_exceptions           :string(10000)
#  can_share                       :boolean          default(FALSE), not null
#  can_stream                      :enum             default("no")
#  can_stream_exceptions           :string(10000)
#  comments                        :text
#  con_state                       :enum             default("not_set")
#  confirmation_sent_at            :datetime
#  confirmation_token              :string
#  confirmed_at                    :datetime
#  current_sign_in_at              :datetime
#  current_sign_in_ip              :inet
#  date_reg_synced                 :datetime
#  demographic_categories          :string
#  do_not_assign_with              :string(10000)
#  encrypted_password              :string           default(""), not null
#  ethnicity                       :string(400)
#  excluded_demographic_categories :string
#  facebook                        :string
#  failed_attempts                 :integer          default(0), not null
#  fediverse                       :string
#  flickr                          :string
#  gender                          :string(400)
#  global_diaspora                 :string
#  indigenous                      :string(10000)
#  instagram                       :string
#  integrations                    :jsonb            not null
#  is_local                        :boolean          default(FALSE)
#  job_title                       :string
#  language                        :string(5)        default("")
#  languages_fluent_in             :string(10000)
#  last_sign_in_at                 :datetime
#  last_sign_in_ip                 :inet
#  linkedin                        :string
#  lock_version                    :integer          default(0)
#  locked_at                       :datetime
#  moderation_experience           :string(10000)
#  name                            :string           default("")
#  name_sort_by                    :string
#  name_sort_by_confirmed          :boolean          default(FALSE)
#  needs_accommodations            :boolean          default(FALSE)
#  non_anglophone                  :string
#  non_us_centric_perspectives     :string(10000)
#  opted_in                        :boolean          default(FALSE), not null
#  organization                    :string
#  othered                         :string(10000)
#  othersocialmedia                :string
#  pronouns                        :string(400)
#  pseudonym                       :string
#  pseudonym_sort_by               :string
#  pseudonym_sort_by_confirmed     :boolean          default(FALSE)
#  published_name                  :string
#  published_name_sort_by          :string
#  reddit                          :string
#  reg_attending_status            :string
#  reg_match                       :enum             default("none")
#  registered                      :boolean          default(FALSE), not null
#  registration_number             :string
#  registration_type               :string
#  remember_created_at             :datetime
#  reset_password_sent_at          :datetime
#  reset_password_token            :string
#  romantic_sexual_orientation     :string
#  sign_in_count                   :integer          default(0), not null
#  tiktok                          :string
#  timezone                        :string(500)
#  twelve_hour                     :boolean          default(TRUE)
#  twitch                          :string
#  twitter                         :string
#  unconfirmed_email               :string
#  unlock_token                    :string
#  website                         :string
#  willing_to_moderate             :boolean          default(FALSE)
#  year_of_birth                   :integer
#  youtube                         :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  reg_id                          :string
#
# Indexes
#
#  idx_people_reg_id                     (reg_id) UNIQUE
#  index_people_on_bio                   (bio) USING gin
#  index_people_on_confirmation_token    (confirmation_token) UNIQUE
#  index_people_on_name                  (name) USING gin
#  index_people_on_pseudonym             (pseudonym) USING gin
#  index_people_on_published_name        (published_name) USING gin
#  index_people_on_reset_password_token  (reset_password_token) UNIQUE
#  index_people_on_unlock_token          (unlock_token) UNIQUE
#
class Person < ApplicationRecord
  # Include default devise modules. Others available are:
  devise :database_authenticatable,
         :timeoutable,
         :rememberable,
         :registerable,
         :recoverable,
         :validatable, :lockable, :trackable

  # TODO: add a deleted_at mechanism for soft deletes

  include PasswordArchivable
  include DirtyAssociations

  has_paper_trail versions: { class_name: 'Audit::PersonVersion' },
                  ignore: [:updated_at, :created_at, :lock_version, :integrations],
                  limit: nil

  before_destroy :check_if_assigned
  before_save :check_primary_email

  has_many  :availabilities

  has_many :magic_Links, dependent: :destroy

  has_many  :session_assignments, dependent: :destroy do
    def publishable
      # get the people with the given role
      where("session_assignments.session_assignment_role_type_id not in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Invisible')")
      .where("session_assignments.session_assignment_role_type_id not in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Reserve')")
      .where("session_assignments.session_assignment_role_type_id is not null AND session_assignments.state != 'rejected'")
    end
  end

  has_many  :sessions, through: :session_assignments do
    def moderating
      where("sessions.status != 'dropped'")
      .where("sessions.start_time is not null and sessions.room_id is not null")
      .where("session_assignments.session_assignment_role_type_id in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Moderator')")
      .where("session_assignments.state != 'rejected'")
    end

    def scheduled
      # get the people with the given role
      where("sessions.status != 'dropped'")
      .where("sessions.start_time is not null and sessions.room_id is not null")
      .where("session_assignments.session_assignment_role_type_id not in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Invisible')")
      .where("session_assignments.session_assignment_role_type_id not in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Reserve')")
      .where("session_assignments.session_assignment_role_type_id is not null AND session_assignments.state != 'rejected'")
    end

    def publishable
      # get the people with the given role
      where("sessions.status != 'draft' and sessions.status != 'dropped' and sessions.visibility = 'public'")
      .where("sessions.start_time is not null and sessions.room_id is not null")
      .where("session_assignments.session_assignment_role_type_id not in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Invisible')")
      .where("session_assignments.session_assignment_role_type_id not in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Reserve')")
      .where("session_assignments.session_assignment_role_type_id is not null AND session_assignments.state != 'rejected'")
    end
  end

  has_many  :person_exclusions, dependent: :destroy
  has_many  :exclusions, through: :person_exclusions

  has_many  :session_limits

  has_many  :person_schedules
  has_many  :person_schedule_approvals, dependent: :destroy
  has_many  :scheduled_sessions,
            -> {
              where("person_schedules.start_time is not null and person_schedules.room_id is not null")
              .where("person_schedules.session_assignment_name in (?)",['Moderator', 'Participant', 'Invisible'])
            },
            class_name: 'PersonSchedule' do
              def not_draft
                where("person_schedules.status != 'draft' AND person_schedules.status != 'dropped'")
              end
            end

  # We let the publish mechanism do the destroy so that the update service knows what is happening
  has_many  :published_session_assignments
  has_many  :published_sessions, through: :published_session_assignments do
    def scheduled
      # get the people with the given role
      where("published_sessions.start_time is not null and published_sessions.room_id is not null")
      .where("published_session_assignments.session_assignment_role_type_id not in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Invisible')")
      .where("published_session_assignments.session_assignment_role_type_id not in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Reserve')")
      .where("published_session_assignments.session_assignment_role_type_id is not null")
    end
  end

  has_many  :person_mailing_assignments
  has_many  :mailings, through: :person_mailing_assignments
  has_many  :mail_histories

  has_many  :email_addresses, dependent: :destroy,
            after_add: :dirty_associations,
            after_remove: :dirty_associations
  accepts_nested_attributes_for :email_addresses, reject_if: :all_blank, allow_destroy: true

  has_many :oauth_identities

  has_one :primary_email,
          -> { where(['email_addresses.isdefault = true']) },
          class_name: 'EmailAddress'

  has_many :submissions, class_name: 'Survey::Submission', dependent: :destroy
  has_many :submitted_surveys, through: :submissions, source: :survey do
    def completed
      # can not rely on just state so look at responses
      where("survey_submissions.id in (select distinct submission_id from survey_responses)")
    end
  end

  has_many :mailed_surveys, through: :mailings, source: :survey
  has_and_belongs_to_many :assigned_surveys, class_name: 'Survey'

  # TODO: get a list of surveys assigned AND those with submissions that are not assigned
  # ?????

  # This is what has also been referred to as "class" of person
  has_many :convention_roles, 
    dependent: :destroy,
    after_add: :dirty_associations,
    after_remove: :dirty_associations
  accepts_nested_attributes_for :convention_roles, allow_destroy: true

  has_and_belongs_to_many :application_roles, class_name: 'ApplicationRole'

  has_many :person_agreements
  has_many :agreements, through: :person_agreements

  has_many :registration_sync_matches, class_name: 'Registration::RegistrationSyncMatch', foreign_key: 'pid'

  # Link to the sync data based on the registration systems id
  has_one :registration_sync_datum,
          class_name: 'RegistrationSyncDatum',
          foreign_key: 'reg_id',
          primary_key: 'reg_id'

  after_update :assigment_consistency

  # TODO:
  # - there is talk about having a workflow, including whether a person
  #   is vetted as a session participant. They could be have declined but
  #   pass vetting and later change their mind. So we do not want to
  #   or need to re-vet...
  #
  enum con_state: {
    not_set: 'not_set',
    applied: 'applied',
    vetted: 'vetted',
    wait_list: 'wait_list',
    invite_pending: 'invite_pending',
    invited: 'invited',
    probable: 'probable',
    accepted: 'accepted',
    declined: 'declined',
    rejected: 'rejected'
  }

  enum reg_match: {none: 'none', automatic: 'automatic', assisted: 'assisted', manual: 'manual', self: 'self'}, _scopes: false

  nilify_blanks only: [
    :bio,
    :pseudonym,
    :website,
    :twitter,
    :fediverse,
    :bsky,
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

  # TODO: these will changle
  enum can_stream: { yes: 'yes', no: 'no', maybe: 'maybe'}, _prefix: true
  enum can_record: { yes: 'yes', no: 'no', maybe: 'maybe'}, _prefix: true
  enum can_photo: { yes: 'yes', no: 'no', maybe: 'maybe'}, _prefix: true

  validates :name, presence: true

  def email
    addr = primary_email || email_addresses.first

    addr&.email
  end

  # TODO: we need to add contact flag to email address
  def contact_email
    primary_email
  end

  def contact_email=(email)
    primary_email = email
  end

  def primary_email=(email)
    # If the email is the same as the primary or any others then
    # we ensure it is flagged as the contact email
    cemail = email_addresses.find_by(email: email)
    if cemail
      cemail.isdefault = true
      cemail.save!
    else
      # Otherwise we add it
      email_addresses.create(email: email, isdefault: true)
    end
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

  def check_primary_email
    return unless email

    count = if id
              EmailAddress.where("person_id != ? and email ilike ? and isdefault = true", id, email.strip).count
            else
              EmailAddress.where("email ilike ? and isdefault = true", email.strip).count
            end

    if count > 0
      raise "That email has been taken by someone else as a primary email address"
    end
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

  # TODO: check
  def saved_change_to_email?
    email_addresses.first&.saved_change_to_email?
  end

  # https://dispatch.moonfarmer.com/separate-email-address-table-with-devise-in-rails-62208a47d3b9
  # mapping.to.find_for_database_authentication(authentication_hash)
  def self.find_first_by_auth_conditions(warden_conditions, opts={})
    conditions = warden_conditions.dup

    # If "email" is an attribute in the conditions,
    # remove it and save to variable
    if (email = conditions.delete(:email))
      # Search through users by condition and also by
      # users who have associations to the provided email
      # change to use primary/default email (we do not check the others)
      where(conditions.to_h)
        .joins(:email_addresses)
        .where("email_addresses.isdefault = true AND email_addresses.email ILIKE ?", email.strip)
        .first
    else
      # If "email" is not an attribute in the conditions,
      # just search for users by the conditions as normal
      where(conditions.to_h).first
    end
  end

  #
  # Override the email changed notification for devise
  #
  def send_email_changed_notification
    prev_email = email_addresses.first.email_before_last_save
    return if prev_email.blank?

    send_devise_notification(
      :email_changed,
      to: prev_email
    )
  end

  # check that the person has not been assigned to program items, if they have then return an error and do not delete
  def check_if_assigned
    if (SessionAssignment.where(person_id: id).count > 0) ||
       (PublishedSessionAssignment.where(person_id: id).count > 0)
      raise 'Cannot delete an assigned person'
    end
  end

  # If the state is changed to decline or rejected then they should not
  # have any assignment roles
  def assigment_consistency
    # unassign when declined or rejected (or should we delete?)
    if con_state == Person.con_states[:declined]
      self.session_assignments.update(
        session_assignment_role_type_id: nil
      )
    elsif con_state == Person.con_states[:rejected]
      self.session_assignments.update(
        session_assignment_role_type_id: nil,
        state: :rejected
      )
    end
  end

  def self.session_counts
    people_table = Person.arel_table
    schedule = PersonSchedule.arel_table

    people_table.project(
      people_table[:id].as('person_id'),
      schedule[:person_id].count.as('session_count')
    )
    .join(schedule, Arel::Nodes::OuterJoin)
    .on(
      schedule[:person_id].eq(people_table[:id])
      .and(schedule[:session_assignment_name].in(['Moderator', 'Participant', 'Invisible']))
      .and(schedule[:start_time].not_eq(nil))
      .and(schedule[:room_id].not_eq(nil))
    )
    .group('people.id')
  end

  # These are here so we can edit and update a person without having
  # to worry about setting their password. Password validation
  # will be done elsewhere
  def valid_password?(password)
    return true if password.blank?

    super
  end

  def password_required?
    new_record? ? false : super
  end
end
