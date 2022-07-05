class PersonSerializer #< ActiveModel::Serializer
  include JSONAPI::Serializer
  include ::Plano::Serializer

  attributes :primary_email, :contact_email

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
              :availability_notes

  # status and comments hidden except for staff
  protected_attributes :con_state, :comments

  # Indicate whether the person has a password set
  protected_attribute :has_password do |person|
    !person.password.blank?
  end

  attribute :tags do |person|
    person.base_tags.collect(&:name)
  end

  has_many  :email_addresses, lazy_load_data: true, serializer: EmailAddressSerializer,
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
  has_many :draft_sessions, lazy_load_data: true, serializer: SessionSerializer,
             links: {
               self: -> (object, params) {
                 "#{params[:domain]}/person/#{object.id}"
               },
               related: -> (object, params) {
                 "#{params[:domain]}/person/#{object.id}/draft_sessions"
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
