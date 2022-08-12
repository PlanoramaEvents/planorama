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

    render status: :ok,
          json: { message: 'publication reset' }.to_json,
          content_type: 'application/json'
  end

  def paginate
    false
  end
end
