module PublicationService

  def self.gen_pub_numbers
    Session.transaction do
      # Get the session elligible for publication, not draft or dropped and must be public
      sessions = Session
                   .where("status != 'draft' and status != 'dropped' and visibility = 'public'")
                   .where("room_id is not null and start_time is not null")

      current_ref = 0
      sessions.each do |session|
        current_ref += 1
        session.pub_reference_number = current_ref
        session.save!
      end
    end
  end

  # Publish the schedule
  # Copy Sessions, and Assignments to Published versions
  def self.publish
    # We only want the public participant roles
    Session.transaction do
      # Get the session elligible for publication, not draft or dropped and must be public
      sessions = Session
                   .where("status != 'draft' and status != 'dropped' and visibility = 'public'")
                   .where("room_id is not null and start_time is not null")

      # published_sessions
      sessions.each do |session|
        pub_session = self.publish_session(session: session)
        pub_session.save!

        # And for assignments
        assignments = session.participant_assignments
                        .where("session_assignments.session_assignment_role_type_id not in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Invisble')")
                        .where("session_assignments.visibility = 'public'")
        assignments.each do |assignment|
          pub_assignment = self.publish_assignment(assignment: assignment, published_session: pub_session)
          pub_assignment.save!
        end
      end
    end
  end

  # pub_session = PublicationService.publish_session(session: session)
  #
  # Published the requested session, if the session already has a published
  # version then we update that otherwise we create one
  def self.publish_session(session:)
    pub_session = PublishedSession.find_by session_id: session.id
    pub_session ||= PublishedSession.new

    session.attributes.each do |attr, val|
      next if val.nil? # if there is nothing to copy skip
      next if !pub_session.attributes.key?(attr) # if the published version does not support the attr skip
      next if [:lock_version, :created_at, :updated_at, :id].include?(attr) # skip lock and dates
      next if pub_session.attributes[attr] == val # skip if the value will not change

      pub_session.send("#{attr}=", val) # the the attr in the publihsed instance
    end
    pub_session.session_id = session.id unless pub_session.session_id # point published to source session

    pub_session
  end

  # Create published versions of the assignments
  def self.publish_assignment(assignment:, published_session:)
    pub_assignment = PublishedSessionAssignment.find_by session_assignment_id: assignment.id
    pub_assignment ||= PublishedSessionAssignment.new

    assignment.attributes.each do |attr, val|
      next if val.nil? # if there is nothing to copy skip
      next if !pub_assignment.attributes.key?(attr) # if the published version does not support the attr skip
      next if [:lock_version, :created_at, :updated_at, :id, :session_id].include?(attr) # skip lock and dates
      next if pub_assignment.attributes[attr] == val # skip if the value will not change

      pub_assignment.send("#{attr}=", val) # the the attr in the publihsed instance
    end
    pub_assignment.session_assignment_id = assignment.id unless pub_assignment.session_assignment_id # point published to source
    pub_assignment.published_session_id = published_session.id unless pub_assignment.published_session_id

    pub_assignment
  end
end
