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

  def self.create_session(sessionTitle:, sessionStartTime:, sessionDuration:, sessionSummary:, hostEmail:, speakerEmails: [], cohostEmails: [])
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
      }.to_json
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
        bio: bio || " ",
        city: city,
        country: country,
      }.to_json
    })
  end

  def self.person_to_airmeet(person)
    speaker_email = person.primary_email.email
    country = nil
    city = nil
    if person.integrations["airmeet"] 
      speaker_email = person.integrations["airmeet"]["speaker_email"] || speaker_email
      country = person.integrations["airmeet"]["country"]
      city = person.integrations["airmeet"]["city"]
    end
    name = person.published_name
    bio = person.bio
    args = {name: name, email: speaker_email, bio: bio}
    if country 
      args[:country] = country
    end
    if city 
      args[:city] = city
    end
    puts args
    result = create_speaker(args)
    puts result
    person.update({integrations: person.integrations.merge({airmeet: {speaker_email: speaker_email, synced: !!result["email"] || (person.integrations["airmeet"] || {})["synced"], data: args, synced_at: !!result["email"] ? Time.now.iso8601 : (person.integrations["airmeet"] || {})["synced_at"] }})})
    result["email"]
  end

  def self.session_to_airmeet(session)
    args = {sessionTitle: "#{session.title} - #{session.format.name}",
      sessionSummary: session.description,
      sessionDuration: session.duration,
      sessionStartTime: session.start_time,
      hostEmail: room_hosts[session.room_id]
    };
    participants = session.published_session_assignments.filter { |sa| sa.session_assignment_role_type_id == moderator_id || sa.session_assignment_role_type_id == participant_id }.map { |sa| sa.person } 
    if session.environment == "virtual"
      args[:speakerEmails] = participants.map{|p| p.integrations["airmeet"]["speaker_email"]}
      args[:cohostEmails] = session.published_session_assignments.filter { |sa| sa.session_assignment_role_type_id == moderator_id }.map { |sa| sa.person.integrations["airmeet"]["speaker_email"] }
    end
    if session.id === "e3e249ee-2800-40cc-a245-f462187833b9"
      args[:sessionTitle] = "Never Give Up, Never Surrender! The Art of Eric Wilkerson: Scifi Illustrator and Visual Afrofuturist"
    end
    puts args
    result = create_session(args);
    puts result
    session.update({integrations: session.integrations.merge({airmeet: {session_id: result["uid"] || (session.integrations["airmeet"] || {})["session_id"], synced: !!result["uid"] || (session.integrations["airmeet"] || {})["synced"] , synced_at: !!result["uid"] ? Time.now() : (session.integrations["airmeet"] || {})["synced_at"] , data: args}})})
    if session.environment == "virtual"
      people_tokens = (result["token"] || []).inject({}) {|p,c| p[c["email"]] = c["token"]; p}
      participants.each { |p| p.update({integrations: p.integrations.merge({airmeet: (p.integrations["airmeet"] || {}).merge({token: people_tokens[(p.integrations["airmeet"] || {})["speaker_email"]]})})})}
    end
  end

  def self.room_hosts
    @room_hosts ||= Room.where.not(integrations: {}).inject({}) { |p, c| p[c.id] = (c.integrations["airmeet"] || {})["room_host_email"]; p }
  end

  def self.virtual_people
    Person.left_outer_joins(:published_session_assignments, :published_sessions, :primary_email)
      .where(published_sessions: { environment: 'virtual' }, published_session_assignments: {session_assignment_role_type_id: [moderator_id, participant_id]})
      .distinct
  end

  def self.virtual_sessions 
    SessionService.published_sessions.where(streamed: true)
  end

  def self.moderator_id
    @moderator_id = SessionAssignmentRoleType.find_by(name: 'Moderator').id
  end

  def self.participant_id
    @participant_id = SessionAssignmentRoleType.find_by(name: 'Participant').id
  end

  def self.sync_to_airmeet
    virtual_people.map { |p, i|
      person_to_airmeet(p)
      puts "Finished person #{i}"
    }
    virtual_sessions.map { |s, i|
      session_to_airmeet(s)
      puts "Finished session #{i}"
    }
    puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA IT WORKED"
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
