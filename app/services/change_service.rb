module ChangeService

  # What changed in date between from date and to date
  def self.session_changes(from:, to: nil)
    {
      sessions: self.sessions_changed(from: from, to: to),
      assignments: self.session_assignments_changed(from: from, to: to)
    }
  end

  # What changed in published date between from date and to date
  def self.published_changes(from:, to: nil)
    {
      sessions: self.published_sessions_changed(from: from, to: to),
      assignments: self.published_session_assignments_changed(from: from, to: to)
    }
  end

  def self.dropped_people(from:, to: nil)
    res = []
    changes = get_changes(clazz: Audit::PersonVersion, type: Person, from: from, to: to)
    changes.each do |id, change|
      if change[:changes]['con_state'] && ['declined', 'rejected'].include?(change[:changes]['con_state'][1] )
        # do not count a "dropped" state to another dropped state
        next if ['declined', 'rejected'].include?(change[:changes]['con_state'][0])

        res.append [change[:object].published_name]
      end
    end
    res.uniq
  end

  def self.session_as_of(session_id:, to:)
    self.object_as_of(audit: Audit::SessionVersion, item_id: session_id, item_type: 'Session', to: to)
  end

  def self.object_as_of(audit:, item_id:, item_type:, to:)
    object_version = audit.where("item_id = ? and item_type = ? and created_at <= ?", item_id, item_type, to)
                      .order('created_at desc')
                      .first
    # We want the object as it is after the change (hence next and reify)
    object = if object_version.next
               # need to apply the changes
               object_version.next.reify
             else
               item_type.constantize.find(item_id) if item_type.constantize.exists?(item_id)
             end

    return object
  end

  def self.assignments_as_of(session_id:, to:)
    moderator = SessionAssignmentRoleType.find_by(name: 'Moderator')
    participant = SessionAssignmentRoleType.find_by(name: 'Participant')

    participants = self.assignments_for(session_id: session_id, role_id: participant.id, to: to)
    moderators = self.assignments_for(session_id: session_id, role_id: moderator.id, to: to)

    {
      participants: participants,
      moderators: moderators
    }
  end

  def self.assignments_for(session_id:, role_id:, to:)
    audits = Audit::SessionVersion
              .where_object(session_id: session_id)
              .where(item_type: 'SessionAssignment')
              .where("created_at <= ?", to)
              .order("created_at desc")
    grouped_audits = audits.group_by {|a| a.item_id}

    res = []
    grouped_audits.each do |key, item_audits|
      change = self.combined_changes(item_audits: item_audits, type: SessionAssignment, to: to)
      res.concat [change[:object]] if self.assigned?(change: change, role_id: role_id)
    end

    res
  end

  def self.assigned?(change:, role_id:)
    return false unless change[:object]

    return true if !change[:changes]['session_assignment_role_type_id'] && change[:object].session_assignment_role_type_id == role_id

    return true if change[:changes]['session_assignment_role_type_id'] && change[:changes]['session_assignment_role_type_id'][1] == role_id

    return false
  end

  def self.sessions_changed(from:, to: nil)
    get_changes(clazz: Audit::SessionVersion, type: Session, from: from, to: to)
  end

  def self.published_sessions_changed(from:, to: nil)
    get_changes(clazz: Audit::PublishedSessionVersion, type: PublishedSession, from: from, to: to)
  end

  def self.session_assignments_changed(from:, to: nil)
    # TODO: may be an issue?
    publishable_sessions = PublicationService.publishable_sessions
    get_changes(clazz: Audit::SessionVersion, type: SessionAssignment, from: from, to: to, publishable_session_ids: publishable_sessions.collect(&:id))
  end

  def self.published_session_assignments_changed(from:, to: nil)
    get_changes(clazz: Audit::PublishedSessionVersion, type: PublishedSessionAssignment, from: from, to: to)
  end

  # get the paper trail verions from: to:
  # we need the versions for each session that has been updated within the period
  # order by the session id and the time (oldest to newest)
  # for each session version get it's change set and "merge" as we go through the time line
  # so we have one final change set per session id which can be used for the report
  def self.get_changes(clazz:, type:, from:, to:, publishable_session_ids: nil)
    # Rails.logger.debug "**** GET #{type} from #{from}"
    changes = {}

    audits = clazz.where("item_type = ?", type.name).order("item_id, created_at asc")

    audits = audits.where("created_at >= ?", from) if from
    audits = audits.where("created_at <= ?", to) if to

    grouped_audits = audits.group_by {|a| a.item_id}

    grouped_audits.each do |key, item_audits|
      # Rails.logger.debug "**** AUDIT #{key} #{publishable_session_ids}"
      # just in case we sort by date
      change = self.combined_changes(item_audits: item_audits, type: type, to: to)
      if publishable_session_ids && change[:object].respond_to?(:session_id)
        next unless publishable_session_ids.include?(change[:object].session_id)
      end

      changes[key] = change
    end

    changes
  end

  def self.combined_changes(item_audits:, type:, to:)
    changes = nil

    item_audits.sort{|a,b| a.created_at <=> b.created_at}.each do |audit|
      # merge the change history
      if changes
        changes[:changes] = self.merge_change_set(to: changes[:changes], from: audit.object_changes)
      else
        # Get the most recent version (as of the to datetime)
        recent = self.object_as_of(audit: audit.class, item_id: audit.item_id, item_type: audit.item_type, to: to)

        # Get the old version of the object
        obj = if audit.event == 'create'
                # reify next just incase is has subsequently been deleted in a later pub and the find/exist will be nil
                res = audit.next ? audit.next.reify : nil
                res ||= type.find(audit.item_id) if type.exists?(audit.item_id)
                res
              else
                audit.reify
              end
        changes = {
          item_id: audit.item_id,
          item_type: audit.item_type,
          event: audit.event,
          object: obj,
          recent: recent,
          changes: audit.object_changes
        }
      end
    end

    changes
  end

  def self.merge_change_set(to: , from:)
    res = to
    from.each do |key, change|
      res[key] = from[key] unless res[key]
      res[key][1] = from[key][1] if res[key]
    end
    res
  end
end
