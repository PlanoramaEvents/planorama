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
class PersonSerializer #< ActiveModel::Serializer
  include JSONAPI::Serializer
  include ::Plano::Serializer

  shareable_attributes :primary_email, :contact_email

  protected_attributes :id, :lock_version,
              :name, :name_sort_by, :name_sort_by_confirmed,
              :pseudonym, :pseudonym_sort_by, :pseudonym_sort_by_confirmed,
              :published_name, :published_name_sort_by,
              :job_title, :organization,
              :current_sign_in_at, :current_sign_in_ip,
              :last_sign_in_at, :last_sign_in_ip,
              :pronouns, :year_of_birth, :gender, :ethnicity,
              :opted_in,
              :can_share,
              :registered, :registration_type, :registration_number,
              :bio, :website, :twitter, :othersocialmedia,
              :fediverse, :bsky,
              :facebook, :linkedin, :twitch, :youtube,
              :instagram, :flickr, :reddit, :tiktok,
              :can_stream,
              :can_record,
              :can_photo,
              :age_at_convention,
              :romantic_sexual_orientation,
              :needs_accommodations,
              :accommodations,
              :willing_to_moderate,
              :moderation_experience,
              :othered,
              :indigenous,
              :black_diaspora,
              :non_us_centric_perspectives,
              :demographic_categories,
              :do_not_assign_with,
              :can_stream_exceptions,
              :can_record_exceptions,
              :can_photo_exceptions,
              :is_local,
              :languages_fluent_in,
              :timezone,
              :twelve_hour,
              :attendance_type,
              :availability_notes,
              :integrations,
              :excluded_demographic_categories,
              :global_diaspora,
              :non_anglophone,
              :reg_id,
              :reg_attending_status,
              :date_reg_synced
              :reg_match

  # status and comments hidden except for staff
  protected_attributes :con_state, :comments

  # Indicate whether the person has a password set
  protected_attribute :has_password do |person|
    !person.encrypted_password.blank?
  end

  attribute :session_count do |person|
    if person.has_attribute?(:session_count)
      person.session_count
    else
      person.scheduled_sessions.count
    end
  end

  has_many  :email_addresses, if: Proc.new { |record, params| AccessControlService.shared_attribute_access?(instance: record, person: params[:current_person]) },
              lazy_load_data: true, serializer: EmailAddressSerializer,
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}/email_addresses"
                }
              }

  has_many :convention_roles, lazy_load_data: true, serializer: ConventionRoleSerializer,
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}/convention_roles"
                }
              }

  has_many  :submissions, lazy_load_data: true, serializer: Survey::SubmissionSerializer,
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}/submissions"
                }
              }

  has_many :completed_surveys, lazy_load_data: true, serializer: SurveySerializer,
             links: {
               self: -> (object, params) {
                 "#{params[:domain]}/person/#{object.id}"
               },
               related: -> (object, params) {
                 "#{params[:domain]}/person/#{object.id}/completed_surveys"
               }
             }

  #
  has_many :mailed_surveys, lazy_load_data: true, serializer: SurveySerializer,
             links: {
               self: -> (object, params) {
                 "#{params[:domain]}/person/#{object.id}"
               },
               related: -> (object, params) {
                 "#{params[:domain]}/person/#{object.id}/mailed_surveys"
               }
             }

  has_many :assigned_surveys, lazy_load_data: true, serializer: SurveySerializer,
            links: {
              self: -> (object, params) {
                "#{params[:domain]}/person/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/person/#{object.id}/assigned_surveys"
              }
            }

  #
  # Availabilities
  has_many :availabilities, lazy_load_data: true, serializer: AvailabilitySerializer,
           links: {
             self: -> (object, params) {
               "#{params[:domain]}/person/#{object.id}"
             },
             related: -> (object, params) {
               "#{params[:domain]}/person/#{object.id}/availability"
             }
           }

  has_many :person_exclusions, lazy_load_data: true, serializer:PersonExclusionSerializer,
          links: {
            self: -> (object, params) {
              "#{params[:domain]}/person/#{object.id}"
            },
            related: -> (object, params) {
              "#{params[:domain]}/person/#{object.id}/person_exclusion"
            }
          }

  has_many :session_limits, lazy_load_data: true, serializer:SessionLimitSerializer,
            links: {
              self: -> (object, params) {
                "#{params[:domain]}/person/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/person/#{object.id}/session_limit"
              }
            }

  # sessions
  has_many :sessions, lazy_load_data: true, serializer: SessionSerializer,
             links: {
               self: -> (object, params) {
                 "#{params[:domain]}/person/#{object.id}"
               },
               related: -> (object, params) {
                 "#{params[:domain]}/person/#{object.id}/sessions"
               }
             }

  # published_sessions
  # has_many :published_sessions, serializer: PublishedSessionSerializer,
  #            links: {
  #              self: -> (object, params) {
  #                "#{params[:domain]}/person/#{object.id}"
  #              },
  #              related: -> (object, params) {
  #                "#{params[:domain]}/person/#{object.id}/published_sessions"
  #              }
  #            }

  has_many :person_schedule_approvals, lazy_load_data: true, serializer: PersonScheduleApprovalSerializer,
            links: {
             self: -> (object, params) {
               "#{params[:domain]}/person/#{object.id}"
             },
             related: -> (object, params) {
               "#{params[:domain]}/person/#{object.id}/person_schedule_approvals"
             }
           }

  has_many :mail_histories, lazy_load_data: true, serializer: MailHistorySerializer,
             links: {
              self: -> (object, params) {
                "#{params[:domain]}/person/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/person/#{object.id}/mail_histories"
              }
            }
end
