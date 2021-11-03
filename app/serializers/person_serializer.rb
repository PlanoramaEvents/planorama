class PersonSerializer #< ActiveModel::Serializer
  include JSONAPI::Serializer

  attributes :id, :lock_version,
             :name, :name_sort_by, :name_sort_by_confirmed,
             :pseudonym, :pseudonym_sort_by, :pseudonym_sort_by_confirmed,
             :published_name, :published_name_sort_by,
             :job_title, :organization,
             :pronouns, :year_of_birth, :gender, :ethnicity,
             :opted_in, :comments,
             :can_share, :can_photo, :can_record,
             :invite_status, :acceptance_status,
             :registered, :registration_type, :registration_number

  # tag_list
  attribute :tags do |person|
   person.base_tags.collect(&:name)
  end

  has_one :bio,
          if: Proc.new { |record| record.bio },
          links: {
            self: -> (object, params) {
              "#{params[:domain]}/person/#{object.id}"
            },
            related: -> (object, params) {
              "#{params[:domain]}/bio/#{object.bio.id}"
            }
          }


  has_many :person_roles, serializer: PersonRoleSerializer,
            links: {
              self: -> (object, params) {
                "#{params[:domain]}/person/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/people/#{object.id}/person_role"
              }
            }

  has_many  :email_addresses, serializer: EmailAddressSerializer,
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}/email_address"
                }
              }

  has_many  :survey_submissions, serializer: Survey::SubmissionSerializer,
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/person/#{object.id}/submission"
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


  # programme_items
  has_many :programme_items, serializer: ProgrammeItemSerializer,
             links: {
               self: -> (object, params) {
                 "#{params[:domain]}/person/#{object.id}"
               },
               related: -> (object, params) {
                 "#{params[:domain]}/person/#{object.id}/programme_items"
               }
             }

  # published_programme_items
  has_many :published_programme_items, serializer: PublishedProgrammeItemSerializer,
             links: {
               self: -> (object, params) {
                 "#{params[:domain]}/person/#{object.id}"
               },
               related: -> (object, params) {
                 "#{params[:domain]}/person/#{object.id}/published_programme_items"
               }
             }

  has_many :mail_histories, serializer: MailHistorySerializer,
             links: {
              self: -> (object, params) {
                "#{params[:domain]}/person/#{object.id}"
              },
              related: -> (object, params) {
                "#{params[:domain]}/person/#{object.id}/mail_histories"
              }
            }
end
