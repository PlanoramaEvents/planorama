module SnapshotService
  # Start
  def self.startSnapshot(label:, author:)
    # Create schedule SnapShot
    snapshot = ScheduleSnapshot.create!(
      label: label,
      status: 'in_progress',
      created_by: author,
      started_at: Time.now
    )

    self.takeSnapshots(schedule_snapshot: snapshot)

    snapshot.update(status: 'done', completed_at: Time.now)
  rescue => e
    Rails.logger.error("Snapshot Failed: #{e}")
    snapshot.update(status: 'failed', completed_at: Time.now)
  end

  # Take snapshot
  # For each participant got through and snapshot their schedule
  # SessionService.draft_schedule_for(person:)
  def self.takeSnapshots(schedule_snapshot:)
    return unless schedule_snapshot

    Person.transaction do
      participants = Person
                      .where("con_state != 'declined' AND con_state != 'rejected'")
                      .where('id in (select person_id from person_schedules)')

      participants.each do |participant|
        # Generate the snapshot
        draft_snapshot = SessionService.draft_schedule_for(person: participant)
        # save the snapshot
        PersonScheduleSnapshot.create!(
          schedule_snapshot: schedule_snapshot,
          person: participant,
          snapshot: draft_snapshot.to_json
        )
      end
    end
  end

end
