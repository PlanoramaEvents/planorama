class MailHistoriesController < ResourceController
  MODEL_CLASS = 'MailHistory'.freeze
  SERIALIZER_CLASS = 'MailHistorySerializer'.freeze
  POLICY_CLASS = 'MailHistoryPolicy'.freeze
  POLICY_SCOPE_CLASS = 'MailHistoryPolicy::Scope'.freeze
  DEFAULT_SORTBY = 'date_sent'.freeze
  DEFAULT_ORDER = 'desc'.freeze

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
end
