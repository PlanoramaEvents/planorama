class MailingSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :testrun, :include_email, :cc_all,
             :mailing_state, :title,
             :last_person_idx,
             :date_sent, :subject, :content,
             :display_name,
             :description,
             :transiton_person_status,
             :survey_id

  belongs_to :sent_by, serializer: PersonSerializer,
              if: Proc.new { |record| record.sent_by_id },
              links: {
                self: -> (object, params) {
                  "#{params[:domain]}/mailing/#{object.id}"
                },
                related: -> (object, params) {
                  "#{params[:domain]}/person/#{object.sent_by_id}"
                }
              }

  attribute :emails do |mailing|
   mailing.primary_email.collect(&:email)
  end
end
