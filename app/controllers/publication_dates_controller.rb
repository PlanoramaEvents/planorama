class PublicationDatesController < ResourceController
  SERIALIZER_CLASS = 'PublicationDateSerializer'.freeze
  POLICY_CLASS = 'PublicationDatePolicy'.freeze
  POLICY_SCOPE_CLASS = 'PublicationDatePolicy::Scope'.freeze
  DEFAULT_SORTBY = 'timestamp'
  DEFAULT_ORDER = 'desc'.freeze

  def reset
    # Make sure that people can not publish etc while we clean up
    if PublicationStatus.last
      PublicationStatus.last.update(status: 'inprogress')

      # Get rid of published data first
      PublishedSession.destroy_all

      # Then get rid of the audit
      Audit::PublishedSessionVersion.delete_all

      # Then remove caches, dates, and status
      PublishSnapshot.delete_all
      PublicationDate.delete_all
      PublicationStatus.delete_all
    end

    render status: :ok,
          json: { message: 'publication reset' }.to_json,
          content_type: 'application/json'
  end

  def paginate
    false
  end

  def allowed_params
    %i[
      id
      lock_version
      sent_external
    ]
  end
end
