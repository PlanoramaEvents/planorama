class PublicationDatesController < ResourceController
  SERIALIZER_CLASS = 'PublicationDateSerializer'.freeze
  POLICY_CLASS = 'PublicationDatePolicy'.freeze
  POLICY_SCOPE_CLASS = 'PublicationDatePolicy::Scope'.freeze
  DEFAULT_SORTBY = 'timestamp'
  DEFAULT_ORDER = 'desc'.freeze

  def reset
    PublishedSession.destroy_all
    PublishSnapshot.delete_all
    PublicationDate.delete_all
    PublicationStatus.delete_all

    Audit::PublishedSessionVersion.delete_all
  end

  def paginate
    false
  end
end
