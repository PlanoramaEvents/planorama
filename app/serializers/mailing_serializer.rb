class MailingSerializer
  include JSONAPI::Serializer

  attributes :id, :lock_version, :created_at, :updated_at,
             :scheduled, :testrun, :include_email, :cc_all,
             :mail_template_id, :last_person_idx

  belongs_to :mail_template,
             links: {
               self: -> (object, params) {
                 "#{params[:domain]}/mailing/#{object.id}"
               },
               related: -> (object, params) {
                 "#{params[:domain]}/mail_template/#{object.mail_template_id}"
               }
            }

  has_many :people

end
