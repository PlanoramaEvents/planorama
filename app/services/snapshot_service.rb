module SnapshotService
  # Kick off a sidekiq job to process the snapshot

  # Take snapshot
  # For each participant got through and snapshot their schedule
  # SessionService.draft_schedule_for(person:)
  def self.takeSnapshots
    participants = Person
                    .where("con_state != 'declined' && con_state != 'rejected'")
                    .where('id in (select person_id from person_schedules)')
    participants.all do |participant|
      snapshot = SessionService.draft_schedule_for(person: participant)
    end
  end

end
