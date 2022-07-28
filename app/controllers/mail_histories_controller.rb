class MailHistoriesController < ResourceController
  MODEL_CLASS = 'MailHistory'.freeze
  # TODO: the classes below
  SERIALIZER_CLASS = 'MailHistorySerializer'.freeze
  POLICY_CLASS = 'MailHistoryPolicy'.freeze
  POLICY_SCOPE_CLASS = 'MailHistoryPolicy::Scope'.freeze

  def belongs_to_param_id
    params[:person_id]
  end

  def belong_to_class
    Person
  end

  def belongs_to_relationship
    'mail_histories'
  end

  def paginate
    false
  end

  # Should be read only
  # def allowed_params
  #   %i[
  #     id
  #     lock_version
  #     person_id
  #     mailing_id
  #     email_status
  #     date_sent
  #     content
  #     subject
  #   ]
  # end
end
