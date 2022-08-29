class PublishedSessionsController < ResourceController
  SERIALIZER_CLASS = 'PublishedSessionSerializer'.freeze
  POLICY_CLASS = 'PublishedSessionPolicy'.freeze

  def resync_airmeet
    authorize current_person, policy_class: policy_class


    #TODO stop mixing up published session and session for integration purposes
    session = PublishedSession.find params[:published_session_id]

    # makes the information in the airmeet sync record match the current session record
    # NOTE: DOES NOT ACTUALLY DO A SYNC TO AIRMEET
    if session
      AirmeetApiService.session_to_airmeet(session, true);
      # clumsily reload person after they are updated
      session = PublishedSession.find params[:published_session_id]
    end

    render_object(session)
  end
end
