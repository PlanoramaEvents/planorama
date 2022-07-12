module SnapshotService
  # Kick off a sidekiq job to process the snapshot

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
        snapshot = SessionService.draft_schedule_for(person: participant)
        # save the snapshot
        PersonScheduleSnapshot.create!(
          schedule_snapshot: schedule_snapshot,
          person: participant,
          snapshot: snapshot.to_json
        )
      end
    end
  end

end
