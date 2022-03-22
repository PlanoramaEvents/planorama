class PersonSerializer #< ActiveModel::Serializer
  include JSONAPI::Serializer
  include ::Plano::Serializer

  protected_attributes :id, :lock_version,
              :name, :name_sort_by, :name_sort_by_confirmed,
              :pseudonym, :pseudonym_sort_by, :pseudonym_sort_by_confirmed,
              :published_name, :published_name_sort_by,
              :job_title, :organization,
              :last_sign_in_at, :primary_email,
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
              :languages_fluent_in

  # status and comments hidden except for staff
  protected_attributes :con_state, :comments

  protected_attributes :contact_email do |person|
    person.contact_email
  end

  # Indicate whether the person has a password set
  protected_attribute :has_password do |person|
    !person.password.blank?
  end

  attribute :tags do |person|
    person.base_tags.collect(&:name)
  end

  has_many  :email_addresses, serializer: EmailAddressSerializer,
              if: Proc.new { |record, params| AccessControlService.allowed_access?(instance: record, person: params[:current_person]) },
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}/email_addresses"
                }
              }

  has_many :convention_roles, serializer: ConventionRoleSerializer,
              if: Proc.new { |record, params| AccessControlService.allowed_access?(instance: record, person: params[:current_person]) },
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}/convention_roles"
                }
              }

  has_many  :submissions, serializer: Survey::SubmissionSerializer,
              if: Proc.new { |record, params| AccessControlService.allowed_access?(instance: record, person: params[:current_person]) },
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}/submissions"
                }
              }

  #
  has_many :mailed_surveys, serializer: SurveySerializer,
             links: {
               self: -> (object, params) {
                 "#{params[:domain]}/person/#{object.id}"
               },
               related: -> (object, params) {
                 "#{params[:domain]}/person/#{object.id}/mailed_surveys"
               }
             }

  has_many :assigned_surveys, serializer: SurveySerializer,
            links: {
              self: -> (object, params) {
                "#{params[:domain]}/person/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/person/#{object.id}/assigned_surveys"
              }
            }


  # sessions
  # has_many :sessions, serializer: SessionSerializer,
  #            if: Proc.new { |record, params| AccessControlService.allowed_access?(instance: record, person: params[:current_person]) },
  #            links: {
  #              self: -> (object, params) {
  #                "#{params[:domain]}/person/#{object.id}"
  #              },
  #              related: -> (object, params) {
  #                "#{params[:domain]}/person/#{object.id}/sessions"
  #              }
  #            }

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

  has_many :mail_histories, serializer: MailHistorySerializer,
             if: Proc.new { |record, params| AccessControlService.allowed_access?(instance: record, person: params[:current_person]) },
             links: {
              self: -> (object, params) {
                "#{params[:domain]}/person/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/person/#{object.id}/mail_histories"
              }
            }
end
