module SessionService
  # SessionService.draft_schedule_for(person: p)
  def self.draft_schedule_for(person:, current_person: nil)
    sched_table = ::PersonSchedule.arel_table
    subquery = Session.area_list.as('areas_list')

    joins = [
      sched_table.create_join(
        subquery,
        sched_table.create_on(
          subquery[:session_id].eq(sched_table[:session_id])
        ),
        Arel::Nodes::OuterJoin
      )
    ]

    schedule = PersonSchedule.select(
        PersonSchedule.arel_table[Arel.star],
        'areas_list.area_list'
      )
      .joins(joins)
      .eager_load(:room, :format, :primary_email)
      .where(person_id: person.id)
      .where("start_time is not null and room_id is not null")
      .where("con_state != 'declined' AND con_state != 'rejected'")
      .where("session_assignment_name in (?)",['Moderator', 'Participant', 'Invisible'])


    PersonScheduleSerializer.new(schedule).serializable_hash
  end
end
