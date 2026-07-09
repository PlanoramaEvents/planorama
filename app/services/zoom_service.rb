require "base64"

#
# Provides a way to absract the Zoom API used by the server side components.
# This is for Zoom events - meetings and webinars
#
class ZoomService
  include HTTParty

  ZOOM_HOST="https://api.zoom.us"
  ZOOM_EVENTS_ENPOINT="/v2/zoom_events"

  def self.event_id
    ::Integration.find_by({name: "zoom"})&.config ? ::Integration.find_by({name: "zoom"})&.config["event_id"] : ''
  end

  def self.account_id
    ::Integration.find_by({name: "zoom"})&.config ? ::Integration.find_by({name: "zoom"})&.config["account_id"] : ''
  end

  def self.client_id
    ::Integration.find_by({name: "zoom"})&.config ? ::Integration.find_by({name: "zoom"})&.config["client_id"] : ''
  end

  def self.client_secret
    ::Integration.find_by({name: "zoom"})&.config ? ::Integration.find_by({name: "zoom"})&.config["client_secret"] : ''
  end

  # Implementation of a zoom events client
  class Client < Members::MemberServices
    attr_accessor :access_token

    def initialize
      account_id = ZoomService.account_id
      client_id = ZoomService.client_id
      client_secret = ZoomService.client_secret
      self.access_token = get_access_token(account_id: account_id, client_id: client_id, client_secret: client_secret)
    end

    #
    # Get the access token needed to make API calls to Zoom
    # 
    def get_access_token(account_id:, client_id:, client_secret:)
      encoded_secret = ZoomService.encode_secret(client_id: client_id, client_secret: client_secret)
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
    def schedule_session(session:)
      event_id = ZoomService.event_id
      url = "#{ZOOM_HOST}/#{ZOOM_EVENTS_ENPOINT}/events/#{event_id}/sessions"
      timezone = ConfigService.value('convention_timezone')

      # TODO: check the session and the room

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
            # TODO
            type: 2, # base on room + format, 2 for meeting, 4 for webinar
            description: session.description,
            featured: false,
            visible_in_landing_page: false,
            featured_in_lobby: false,
            visible_in_lobby: false,
            is_simulive: false,
            chat_channel: false,
            led_by_sponsor: false,
            attendance_type: "virtual", # All sessions are "virtual"
            # TODO: tags? "room"?
          }.to_json
        )

        # TODO: add the zoom info to the session
    end

    # remove the given session from zoom events
    def unschedule_session(session:)
      session_id = "SwiGAF2pQKqz544C2l1ojg"
      event_id = ZoomService.event_id
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
      # TODO: remove the zoom info from the session
    end

    # update the given sesion in zoom events
    def update_session(session:)
      event_id = ZoomService.event_id
      url = "#{ZOOM_HOST}/#{ZOOM_EVENTS_ENPOINT}/events/#{event_id}/sessions/#{session_id}"

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
        }.to_json
      )
    end
  end

  #
  # Instantiate an instance of the Zoom service
  #
  def self.get_svc
    ZoomService::Client.new
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
