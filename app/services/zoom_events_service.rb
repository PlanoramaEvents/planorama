require "base64"

#
# Provides a way to absract the Zoom API used by the server side components.
# This is for Zoom events - meetings and webinars
#
class ZoomEventsService
  include HTTParty

  ZOOM_HOST="https://api.zoom.us"
  ZOOM_EVENTS_ENPOINT="/v2/zoom_events"

  def self.zoom_enabled
    ::Integration.find_by({name: "zoom"})&.config ? ::Integration.find_by({name: "zoom"})&.config["enabled"] : false
  end

  def self.event_id
    ::Integration.find_by({name: "zoom"})&.config ? ::Integration.find_by({name: "zoom"})&.config["event_id"] : nil
  end

  def self.account_id
    ::Integration.find_by({name: "zoom"})&.config ? ::Integration.find_by({name: "zoom"})&.config["account_id"] : nil
  end

  def self.client_id
    ::Integration.find_by({name: "zoom"})&.config ? ::Integration.find_by({name: "zoom"})&.config["client_id"] : nil
  end

  def self.client_secret
    ::Integration.find_by({name: "zoom"})&.config ? ::Integration.find_by({name: "zoom"})&.config["client_secret"] : nil
  end

  # Implementation of a zoom events client
  class Client
    attr_accessor :access_token

    def initialize
      account_id = ZoomEventsService.account_id
      client_id = ZoomEventsService.client_id
      client_secret = ZoomEventsService.client_secret
      self.access_token = get_access_token(account_id: account_id, client_id: client_id, client_secret: client_secret)
    end

    #
    # Get the access token needed to make API calls to Zoom
    # 
    def get_access_token(account_id:, client_id:, client_secret:)
      encoded_secret = ZoomEventsService.encode_secret(client_id: client_id, client_secret: client_secret)
      url = "https://zoom.us/oauth/token"

      response = HTTParty.post(
          url,
          headers: {
            'Authorization' => "Basic #{encoded_secret}",
            'Accept' => 'application/json',
            'Host' => 'zoom.us',
            "Content-Type" => "application/x-www-form-urlencoded"
          },
          body: {
            grant_type: 'account_credentials',
            account_id: account_id
          }
        )
    end

    # 
    # List the events, by default we only get the events that are draft
    # unless otherwise specified using the status_type parameter
    # 
    def list_events(status_type: 'draft')
      url = "#{ZOOM_HOST}/#{ZOOM_EVENTS_ENPOINT}/events"
      response = HTTParty.get(
          url,
          headers: {
            'Authorization' => "Bearer #{self.access_token['access_token']}",
            'Accept' => 'application/json',
            'Host' => 'zoom.us',
            "Content-Type" => "Content-Type: application/json"
          },
          query: {
            role_type: 'host',
            event_status_type: status_type #'draft'
          }
      )
    end

    # 
    # Only rooms that are online and sessions that are virtual/hybrid get zoom sessions
    # Based on the given session create a zoom meeting for the event
    # 
    def schedule_session(session:, meeting_type:)
      event_id = ZoomEventsService.event_id
      url = "#{ZOOM_HOST}/#{ZOOM_EVENTS_ENPOINT}/events/#{event_id}/sessions"
      timezone = ConfigService.value('convention_timezone')

      tags = session.taggings.select{|t| t.context == 'tags'}.collect(&:tag).collect(&:name)
      tags << "Replay" if session.recorded

      response = HTTParty.post(
          url,
          headers: {
            'Authorization' => "Bearer #{self.access_token['access_token']}",
            'Accept' => 'application/json',
            'Host' => 'zoom.us',
            "Content-Type" => "application/json"
          },
          body: {
            name: session.title,
            start_time: session.start_time.strftime("%Y-%m-%dT%H:%M:%SZ"), # as UTC
            end_time: (session.start_time + session.duration.minutes).strftime("%Y-%m-%dT%H:%M:%SZ"),
            timezone: "America/Los_Angeles",
            type: (meeting_type == "webinar" ? 2 : 0), # 0 for meeting, 2 for webinar
            description: session.description,
            featured: false,
            visible_in_landing_page: false,
            featured_in_lobby: false,
            visible_in_lobby: false,
            is_simulive: false,
            chat_channel: false,
            led_by_sponsor: false,
            attendance_type: "virtual", # All sessions are "virtual"
            # Use the track as the room
            track_labels: [
              session.room.name
            ],
            # Use the public tags as the "product" labels
            product_labels: tags,
            # Set of alternate hosts
            alternative_host: [session.room.integrations['zoom']['alternate_host']]
          }.to_json
        )

        # add the zoom info to the session
        result = JSON.parse(response.body)
        session.integrations = {zoom_session_id: result["session_id"], zoom_meeting_type: meeting_type}
        session.save!
    end

    # remove the given session from zoom events
    def unschedule_session(session:)
      session_id = session.integrations['zoom_session_id']

      raise "There is no zoom session for #{session.title}" unless session_id

      event_id = ZoomEventsService.event_id
      url = "#{ZOOM_HOST}/#{ZOOM_EVENTS_ENPOINT}/events/#{event_id}/sessions/#{session_id}"

      response = HTTParty.delete(
        url,
        headers: {
          'Authorization' => "Bearer #{self.access_token['access_token']}",
          'Accept' => 'application/json',
          'Host' => 'zoom.us',
          "Content-Type" => "application/json"
        }
      )

      # remove the zoom info from the session
      session.integrations = {}
      session.save!
    end

    # update the given sesion in zoom events
    # NOTE: we can not change the type of the session
    def update_session(session:)
      session_id = session.integrations['zoom_session_id']

      raise "There is no zoom session for #{session.title}" unless session_id

      event_id = ZoomEventsService.event_id
      url = "#{ZOOM_HOST}/#{ZOOM_EVENTS_ENPOINT}/events/#{event_id}/sessions/#{session_id}"

      tags = session.taggings.select{|t| t.context == 'tags'}.collect(&:tag).collect(&:name)
      tags << "Replay" if session.recorded

      # Only patch the pieces that may have change, title, description and time
      response = HTTParty.patch(
        url,
        headers: {
          'Authorization' => "Bearer #{self.access_token['access_token']}",
          'Accept' => 'application/json',
          'Host' => 'zoom.us',
          "Content-Type" => "application/json"
        },
        body: {
          name: session.title,
          start_time: session.start_time.strftime("%Y-%m-%dT%H:%M:%SZ"),
          end_time: (session.start_time + session.duration.minutes).strftime("%Y-%m-%dT%H:%M:%SZ"),
          timezone: "America/Los_Angeles",
          description: session.description,
          # Use the track as the room
          track_labels: [
            session.room.name
          ],
          # Use the public tags as the "product" labels
          product_labels: tags,
          # Set of alternate hosts
          alternative_host: [session.room.integrations['zoom']['alternate_host']]
        }.to_json
      )
    end
  end

  #
  # Instantiate an instance of the Zoom service
  #
  def self.get_svc
    ZoomEventsService::Client.new
  end

  private

  # 
  # Encode the Zoom client and secret so we can use
  # to get the access token
  # 
  def self.encode_secret(client_id:, client_secret:)
    Base64.urlsafe_encode64("#{client_id}:#{client_secret}", padding: false)
  end  
end
