# == Schema Information
#
# Table name: mailings
#
#  id                      :uuid             not null, primary key
#  cc_all                  :boolean          default(FALSE)
#  content                 :text
#  date_sent               :datetime
#  description             :text
#  include_email           :boolean          default(TRUE)
#  last_person_idx         :integer          default(-1)
#  lock_version            :integer          default(0)
#  mailing_state           :enum             default("draft")
#  subject                 :string
#  testrun                 :boolean          default(FALSE)
#  title                   :string
#  transiton_person_status :enum
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  sent_by_id              :uuid
#  survey_id               :uuid
#
# Indexes
#
#  index_mailings_on_mailing_state  (mailing_state)
#
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
