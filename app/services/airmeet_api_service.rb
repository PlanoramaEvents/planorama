module AirmeetApiService
  def self.integration
    @integration ||= Integration.find_or_create_by({name: :airmeet})
  end

  def self.config
    integration.config
  end

  def self.token
    if !config['token'] || Time.at(config['token_exp']) < Time.now
      auth
    else
      config['token']
    end
  end

  def self.airmeet_id
    config['airmeet_id']
  end

  def self.airmeet
    @airmeet ||= Airmeet.new
  end

  def self.get_participants
    Airmeet.get("/airmeet/#{airmeet_id}/participants")
  end

  def self.auth
    token = airmeet.auth["token"]
    integration.update({config: config.merge({ 
      token: token, 
      token_exp: (Time.now + (29 * 24 * 60 * 60)).to_i 
    })})
    token
  end

  def self.info
    Airmeet.get("/airmeet/#{airmeet_id}/info")
  end

  def self.get_session(id)
    info["sessions"].find { |s| s["sessionid"] == id }
  end

  def self.create_session(sessionTitle:, sessionStartTime:, sessionDuration:, sessionSummary:, hostEmail:, speakerEmails:, cohostEmails:)
    sessionStartTime = sessionStartTime.to_i * 1000
    Airmeet.post("/airmeet/#{airmeet_id}/session", {
      body: {
        sessionTitle: sessionTitle,
        sessionStartTime: sessionStartTime,
        sessionDuration: sessionDuration,
        sessionSummary: sessionSummary,
        hostEmail: hostEmail,
        speakerEmails: speakerEmails,
        cohostEmails: cohostEmails,
        type: "HOSTING"
      }
    })
  end

  def self.create_speaker(name:, email:, organisation: "", designation: "", imageUrl:  "", bio: "", city: "", country: "")
    Airmeet.post("/airmeet/#{airmeet_id}/speaker", {
      body: {
        name: name,
        email: email,
        organisation: organisation,
        designation: designation,
        imageUrl: imageUrl,
        bio: bio,
        city: city,
        country: country,
      }.to_json
    })
  end

  def self.person_to_airmeet(person)
    speaker_email = person.primary_email.email
    if person.integrations["airmeet"] 
      speaker_email = person.integrations["airmeet"]["speaker_email"]
      if person.integrations["airmeet"]["synced"]
        return speaker_email
      end
    end
    name = person.published_name
    bio = person.bio
    result = create_speaker({name: name, email: speaker_email, bio: bio})
    puts result
    person.update({integrations: person.integrations.merge({airmeet: {speaker_email: result["email"], synced: true, name: name, bio: bio, synced_at: Time.now.iso8601}})})
    result["email"]
  end

  def self.session_to_airmeet(session)
    args = {sessionTitle: "#{session.room.name} - #{session.title} - #{session.format.name} - #{session.area_list.join(", ")}",
    sessionSummary: session.description,
    sessionDuration: session.duration,
    sessionStartTime: session.start_time,
    hostEmail: session.room.integrations["airmeet"]["room_host_email"],
    speakerEmails: session.session_assignments.map { |sa| sa.person.integrations.airmeet.speaker_email},
    cohostEmails: session.session_assignments.filter { |sa| sa.session_assignment_role_type_id == moderator_id }.map { |sa| sa.person.integrations.airmeet.speaker_email }}
    result = create_session(args);
    session.update({integrations: session.integrations.merge({airmeet: {session_id: result.id, synced: true, synced_at: Time.now()}})})
  end

  class Airmeet
    include HTTParty
    base_uri "https://api-gateway.airmeet.com/prod"
    
    headers 'Content-Type' => 'application/json' 

    # TODO fix me for not testing
    default_options.update(verify: false)

    def auth
      self.class.post("/auth", {
        headers: {
          "X-Airmeet-Access-Key": ENV["AIRMEET_ACCESS_KEY"],
          "X-Airmeet-Secret-Key": ENV["AIRMEET_SECRET_KEY"],
          "X-Airmeet-Access-Token": ""
        },
        verify: false
      })
    end

    headers 'X-Airmeet-Access-Token' => AirmeetApiService.token


  end
  
end
