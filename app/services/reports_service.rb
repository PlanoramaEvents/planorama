module ReportsService
  def self.panels_with_too_few_people
    sub = self.sessions_and_participant_count.as("session_list")
    self.panels_with_counts(sub).where(sub[:nbr_assignments].lteq(3))
  end

  def self.panels_with_too_many_people
    sub = self.sessions_and_participant_count.as("session_list")
    self.panels_with_counts(sub).where(sub[:nbr_assignments].gteq(6))
  end

  def self.panels_with_counts(sub)
    session_table = Session.arel_table
    sessions = Session.select(
        ::Session.arel_table[Arel.star],
        sub[:nbr_assignments],
        'areas_list.area_list'
      )
      .joins(
        [
          session_table.create_join(
            sub,
            session_table.create_on(
              sub[:id].eq(session_table[:id])
            ),
            Arel::Nodes::OuterJoin
          )
        ]
      )
      .joins(area_subquery)
      .eager_load(:areas, {session_assignments: [:person]})
      .where("session_assignments.session_assignment_role_type_id is not null")
  end

  def self.area_subquery
    session_table = Session.arel_table
    areas_list = Session.area_list.as('areas_list')
    [
      session_table.create_join(
        areas_list,
        session_table.create_on(
          areas_list[:session_id].eq(session_table[:id])
        ),
        Arel::Nodes::OuterJoin
      )
    ]
  end

  def self.sessions_and_participant_count
    format = Format.find_by(name: 'Panel')
    active_roles = SessionAssignmentRoleType.where("role_type = 'participant' and (name != 'Invisible' or name != 'Reserve')")
    sessions = Session.arel_table
    session_assignments = SessionAssignment.arel_table

    sessions.project(sessions[:id], session_assignments[:id].count.as('nbr_assignments'))
      .join(session_assignments, Arel::Nodes::OuterJoin).on(sessions[:id].eq(session_assignments[:session_id]))
      .where(
        sessions[:format_id].eq(format.id).and(
          session_assignments[:session_assignment_role_type_id].not_eq(nil).and(
            session_assignments[:session_assignment_role_type_id].in(active_roles.collect{|a| a.id})
          )
        )
      )
      .group('sessions.id')
  end
end
