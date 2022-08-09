class PublicationDatesController < ResourceController
  SERIALIZER_CLASS = 'PublicationDateSerializer'.freeze
  POLICY_CLASS = 'PublicationDatePolicy'.freeze
  POLICY_SCOPE_CLASS = 'PublicationDatePolicy::Scope'.freeze
  DEFAULT_SORTBY = 'timestamp'
  DEFAULT_ORDER = 'desc'.freeze

  def paginate
    false
  end
end
