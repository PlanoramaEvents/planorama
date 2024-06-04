module PublicationService

  #
  def self.start_publish_job
    pstatus = PublicationStatus.order('created_at desc').first
    pstatus = PublicationStatus.new if pstatus == nil
    if pstatus.status != 'inprogress'
      pstatus.status = 'inprogress'
      pstatus.save!

      PublicationWorker.perform_async
    end
  end

  def self.gen_pub_numbers
    Session.transaction(joinable: false, requires_new: true) do
      sessions = publishable_sessions

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
  # only deal with sessions and assignments chances since
  def self.publish(since: nil)
    res = {}
    Session.transaction(joinable: false, requires_new: true) do
      session_results = self.publish_sessions(sessions: self.publishable_sessions, since: since)
      assignment_results = self.publish_assignments(sessions: self.publishable_sessions, since: since)

      res = session_results.merge(assignment_results)
    end
    res
  end

  #  POST published - create a cache for the published schedule

  def self.publish_sessions(sessions:, since:)
    candidates = if since
                   sessions.where("sessions.updated_at >= ?", since)
                  else
                    sessions
                  end

    # updated
    updated_sessions = self.publish_updated_sessions(candidates)
    # new
    new_sessions = self.publish_new_sessions(candidates)
    # dropped
    dropped_sessions = self.remove_dropped_sessions(sessions)

    {
      new_sessions: new_sessions,
      updated_sessions: updated_sessions,
      dropped_sessions: dropped_sessions
    }
  end

  def self.publish_assignments(sessions:, since:)
    # ensure we get assignments added before the session was made publishable ....
    candidates = self.publishable_assignments(sessions: sessions)

    # updated
    updated_assignments = self.publish_updated_assignments(candidates)
    # new
    new_assignments = self.publish_new_assignments(candidates)
    # dropped
    dropped_assignments = self.remove_dropped_assignments(self.publishable_assignments(sessions: sessions))

    {
      new_assignments: new_assignments,
      updated_assignments: updated_assignments,
      dropped_assignments: dropped_assignments
    }
  end

  def self.publish_new_sessions(sessions)
    candidates = if PublishedSession.count > 0
                   sessions.where("id not in (?)", PublishedSession.all.collect(&:session_id))
    else
      sessions
    end
    count = candidates.count

    candidates.each do |session|
      pub_session = self.publish_session(session: session, update: false)
      pub_session.save! if pub_session
    end
    count
  end

  def self.publish_updated_sessions(sessions)
    candidates = sessions.where("id in (?)", PublishedSession.all.collect(&:session_id))
    count = candidates.count

    candidates.each do |session|
      pub_session = self.publish_session(session: session)
      pub_session.save!
    end

    count
  end

  def self.remove_dropped_sessions(sessions)
    candidates = PublishedSession.where("session_id not in (?)", sessions.collect(&:id))
    count = candidates.count
    candidates.destroy_all
    count
  end

  # Published (create or update) the requested session, if the session already has a published
  # version then we update that otherwise we create one
  def self.publish_session(session:, update: true)
    pub_session = PublishedSession.find_by session_id: session.id
    pub_session ||= PublishedSession.new unless update

    return unless pub_session

    session.attributes.each do |attr, val|
      next if val.nil? # if there is nothing to copy skip
      next if !pub_session.attributes.key?(attr) # if the published version does not support the attr skip
      next if ['lock_version', 'created_at', 'updated_at', 'id'].include?(attr) # skip lock and dates
      next if pub_session.attributes[attr] == val # skip if the value will not change

      pub_session.send("#{attr}=", val) # the the attr in the publihsed instance
    end
    # Need to copy the tags to the puiblished session
    pub_session.tag_list = session.tag_list

    pub_session.session_id = session.id unless pub_session.session_id # point published to source session

    pub_session
  end

  #
  def self.publish_new_assignments(assignments)
    candidates = if PublishedSessionAssignment.count > 0
                   assignments.where("id not in (?)", PublishedSessionAssignment.all.collect(&:session_assignment_id))
    else
      assignments
    end

    count = candidates.count

    candidates.each do |assignment|
      pub_assignment = self.publish_assignment(assignment: assignment, update: false)
      pub_assignment.save!
    end

    count
  end

  def self.publish_updated_assignments(assignments)
    candidates = assignments.where("id not in (?)", PublishedSessionAssignment.all.collect(&:session_assignment_id))
    count = candidates.count

    candidates.each do |assignment|
      pub_assignment = self.publish_assignment(assignment: assignment)
      pub_assignment.save! if pub_assignment
    end

    count
  end

  def self.remove_dropped_assignments(assignments)
    candidates = PublishedSessionAssignment.where("session_assignment_id not in (?) or session_assignment_id not in (select id from session_assignments)", assignments.collect(&:id))
    count = candidates.count
    candidates.destroy_all
    count
  end

  # Create published versions of the assignments
  def self.publish_assignment(assignment:, update: true)
    pub_assignment = PublishedSessionAssignment.find_by session_assignment_id: assignment.id
    pub_assignment ||= PublishedSessionAssignment.new unless update

    return unless pub_assignment

    assignment.attributes.each do |attr, val|
      next if val.nil? # if there is nothing to copy skip
      next if !pub_assignment.attributes.key?(attr) # if the published version does not support the attr skip
      next if ['lock_version', 'created_at', 'updated_at', 'id', 'session_id'].include?(attr) # skip lock and dates
      next if pub_assignment.attributes[attr] == val # skip if the value will not change

      pub_assignment.send("#{attr}=", val) # the the attr in the publihsed instance
    end
    pub_assignment.session_assignment_id = assignment.id unless pub_assignment.session_assignment_id # point published to source
    pub_assignment.published_session_id = assignment.session_id unless pub_assignment.published_session_id

    pub_assignment
  end

  # Get the session elligible for publication, not draft or dropped and must be public
  def self.publishable_sessions
    Session
      .where("status != 'draft' and status != 'dropped' and visibility = 'public'")
      .where("room_id is not null and start_time is not null")
  end

  def self.publishable_assignments(sessions:)
    SessionAssignment
      .where("session_assignments.session_id in (?)", sessions.collect(&:id))
      .where("session_assignments.session_assignment_role_type_id not in (select id from session_assignment_role_type where session_assignment_role_type.name = 'Reserve')")
      .where("session_assignments.visibility = 'public'")
  end
end
