## schema
# CREATE TABLE public.people (
#     id integer NOT NULL,
#     first_name character varying(150),
#     last_name character varying(150) DEFAULT ''::character varying,
#     suffix character varying(50),
#     language character varying(5) DEFAULT ''::character varying,
#     created_at timestamp without time zone NOT NULL,
#     updated_at timestamp without time zone NOT NULL,
#     lock_version integer DEFAULT 0,
#     comments text,
#     organization character varying,
#     job_title character varying,
#     prefix character varying(50),
#     pseudonym_first_name character varying(150),
#     pseudonym_last_name character varying(150),
#     pseudonym_suffix character varying(50),
#     pseudonym_prefix character varying(50),
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
#     published_name character varying(400) GENERATED ALWAYS AS (
# CASE
#     WHEN ((pseudonym_last_name IS NOT NULL) OR (pseudonym_first_name IS NOT NULL)) THEN
#     CASE
#         WHEN (pseudonym_first_name IS NULL) THEN (pseudonym_first_name)::text
#         WHEN (pseudonym_last_name IS NULL) THEN (pseudonym_last_name)::text
#         ELSE (((pseudonym_first_name)::text || ' '::text) || (pseudonym_last_name)::text)
#     END
#     ELSE
#     CASE
#         WHEN (first_name IS NULL) THEN (last_name)::text
#         WHEN (last_name IS NULL) THEN (first_name)::text
#         ELSE (((first_name)::text || ' '::text) || (last_name)::text)
#     END
# END) STORED,
#     published_last_name character varying(400) GENERATED ALWAYS AS (
# CASE
#     WHEN (pseudonym_last_name IS NOT NULL) THEN pseudonym_last_name
#     ELSE last_name
# END) STORED,
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
#     locked_at timestamp without time zone
# );

class Person < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # database_authenticatable,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :lockable

  acts_as_taggable

  has_paper_trail

  has_one :bio, dependent: :delete
  accepts_nested_attributes_for :bio, allow_destroy: true

  before_destroy :check_if_assigned

  has_many  :programme_assignments, dependent: :destroy
  has_many  :programme_items, through: :programme_assignments

  # We let the publish mechanism do the destroy so that the update service knows what is happening
  has_many  :published_programme_assignments
  has_many  :published_programme_items, through: :published_programme_assignments

  has_many  :person_mailing_assignments
  has_many  :mailings, through: :person_mailing_assignments
  has_many  :mail_histories # , :through => :person_mailing_assignments

  has_many  :email_addresses
  accepts_nested_attributes_for :email_addresses, reject_if: :all_blank, allow_destroy: true

  has_many :survey_submissions, class_name: 'Survey::Submission', dependent: :destroy
  # TODO: add scope for survey id
  # TODO: get list of surveys for this person ...

  has_many :person_roles

  enum acceptance_status: {
    unknown: 'unknown',
    probable: 'probable',
    accepted: 'accepted',
    declined: 'declined'
  }

  enum invitestatus: {
    not_set: 'not_set',
    do_not_invite: 'do_not_invite',
    potential_invite: 'potential_invite',
    invite_pending: 'invite_pending',
    invited: 'invited',
    volunteered: 'volunteered'
  }

  nilify_blanks only: [
    :bio,
    :first_name,
    :pseudonym_prefix,
    :pseudonym_first_name,
    :pseudonym_last_name,
    :pseudonym_suffix
  ]

  validates :last_name, presence: true


  # TODO:
  # - there is talk about having a workflow, including whether a person
  #   is vetted as a programme participant. They could be have declined but
  #   pass vetting and later change their mind. So we do not want to
  #   or need to re-vet...
  #
  def email
    email_addresses.first&.email
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

  def primary_email
    # TODO: change to find the primary email
    email_addresses.first&.email
    # emails.primary || (emails.first if new_record?)
  end

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
    if (ProgrammeAssignment.where(person_id: id).count > 0) ||
       (PublishedProgrammeAssignment.where(person_id: id).count > 0)
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

  # # ----------------------------------------------------------------------------------------------
  # TODO: part of refactor
  # has_one :available_date, :dependent => :delete
  # has_one :person_constraints, :dependent => :delete # THis is the max items per day & conference
  # has_many  :exclusions, :dependent => :delete_all
  # has_many  :excluded_people, :through => :exclusions,
  #           :source => :excludable,
  #           :source_type => 'Person' do
  #             def find_by_source(s)
  #               where(['source = ?', s])
  #             end
  #           end
  # has_many  :excluded_items, :through => :exclusions,
  #           :source => :excludable,
  #           :source_type => "ProgrammeItem" do
  #             def find_by_source(s)
  #               where(['source = ?', s])
  #             end
  #           end
  # # ----------------------------------------------------------------------------------------------
end
