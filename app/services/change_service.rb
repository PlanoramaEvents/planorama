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

  def self.sessions_changed(from:, to: nil)
    get_changes(clazz: Audit::SessionVersion, type: Session, from: from, to: to)
  end

  def self.published_sessions_changed(from:, to: nil)
    get_changes(clazz: Audit::PublishedSessionVersion, type: PublishedSession, from: from, to: to)
  end

  def self.session_assignments_changed(from:, to: nil)
    get_changes(clazz: Audit::SessionVersion, type: SessionAssignment, from: from, to: to)
  end

  def self.published_session_assignments_changed(from:, to: nil)
    get_changes(clazz: Audit::PublishedSessionVersion, type: PublishedSessionAssignment, from: from, to: to)
  end

  # get the paper trail verions from: to:
  # we need the versions for each session that has been updated within the period
  # order by the session id and the time (oldest to newest)
  # for each session version get it's change set and "merge" as we go through the time line
  # so we have one final change set per session id which can be used for the report
  def self.get_changes(clazz:, type:, from:, to:)
    changes = {}

    audits = clazz.where("item_type = ?", type.name).order("item_id, created_at asc")

    audits = audits.where("created_at >= ?", from) if from
    audits = audits.where("created_at <= ?", to) if to

    grouped_audits = audits.group_by {|a| a.item_id}

    grouped_audits.each do |key, item_audits|
      # just in case we sort by date
      item_audits.sort{|a,b| a.created_at <=> b.created_at}.each do |audit|
        # merge the change history
        if changes[key]
          changes[key][:changes] = self.merge_change_set(to: changes[key][:changes], from: audit.object_changes)
        else
          obj = type.find(audit.item_id) if audit.event != 'destroy' && type.exists?(audit.item_id)
          obj ||= audit.reify
          changes[key] = {event: audit.event, object: obj, changes: audit.object_changes}
        end
      end
    end

    # TODO: any way we can order by the session title ???
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
