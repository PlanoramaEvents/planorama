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

  # acts_as_taggable
  acts_as_taggable_on :tags

  has_paper_trail versions: { class_name: 'Audit::PersonVersion' }, ignore: [:updated_at, :created_at]

  before_destroy :check_if_assigned
  before_save :check_primary_email

  has_many  :availabilities

  has_many  :session_assignments, dependent: :destroy
  has_many  :sessions, through: :session_assignments

  has_many  :person_exclusions, dependent: :destroy
  has_many  :exclusions, through: :person_exclusions

  has_many  :session_limits

  has_many  :person_schedules
  has_many  :person_schedule_approvals, dependent: :destroy
  has_many  :scheduled_sessions,
            -> {
              where("person_schedules.start_time is not null and person_schedules.room_id is not null")
              .where("person_schedules.session_assignment_name in (?)",['Moderator', 'Participant']) #, 'Invisible'
            },
            class_name: 'PersonSchedule'

  # We let the publish mechanism do the destroy so that the update service knows what is happening
  # has_many  :published_session_assignments
  # has_many  :published_sessions, through: :published_session_assignments

  has_many  :person_mailing_assignments
  has_many  :mailings, through: :person_mailing_assignments
  has_many  :mail_histories

  has_many  :email_addresses, dependent: :destroy
  accepts_nested_attributes_for :email_addresses, reject_if: :all_blank, allow_destroy: true

  has_one :primary_email,
          -> { where(['email_addresses.isdefault = true']) },
          class_name: 'EmailAddress'

  has_many :submissions, class_name: 'Survey::Submission', dependent: :destroy
  has_many :mailed_surveys, through: :mailings, source: :survey
  has_and_belongs_to_many :assigned_surveys, class_name: 'Survey'

  # TODO: get a list of surveys assigned AND those with submissions that are not assigned
  # ?????

  # This is what has also been referred to as "class" of person
  has_many :convention_roles, dependent: :destroy
  accepts_nested_attributes_for :convention_roles, allow_destroy: true

  has_and_belongs_to_many :application_roles, class_name: 'ApplicationRole'

  has_many  :person_agreements
  has_many  :agreements, through: :person_agreements

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
      self.session_assignments.update_all(
        session_assignment_role_type_id: nil
      )
    elsif con_state == Person.con_states[:rejected]
      self.session_assignments.update_all(
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
      .and(schedule[:session_assignment_name].in(['Moderator', 'Participant']))
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
