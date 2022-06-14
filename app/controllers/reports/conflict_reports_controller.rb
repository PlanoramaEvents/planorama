class Reports::ConflictReportsController < ApplicationController
  around_action :set_timezone

  def people_outside_availability
    authorize SessionAssignment, policy_class: Reports::ConflictReportsPolicy

    conflicts_table = Arel::Table.new(Conflicts::AvailabilityConflict.table_name)
    subquery = Session.area_list.as('areas_list')
    joins = [
      conflicts_table.create_join(
        subquery,
        conflicts_table.create_on(
          subquery[:session_id].eq(conflicts_table[:session_id])
        ),
        Arel::Nodes::OuterJoin
      )
    ]

    conflicts = Conflicts::AvailabilityConflict.select(
                    ::Conflicts::AvailabilityConflict.arel_table[Arel.star],
                    'areas_list.area_list'
                  )
                  .includes(:session, :person)
                  .joins(joins)
                  .where("session_assignment_name is null or session_assignment_name in ('Moderator', 'Participant', 'Invisible')")
                  .order('people.published_name')


    workbook = FastExcel.open(constant_memory: true)
    worksheet = workbook.add_worksheet("People Outside Availability")

    worksheet.append_row(
      [
        'Name',
        'Pub Name',
        'Session',
        'Areas',
        'Start Time',
        'Reason'
      ]
    )
    date_time_style = workbook.number_format("d mmm yyyy h:mm")
    styles = [nil, nil, nil, nil, date_time_style, nil]

    conflicts.each do |conflict|
      worksheet.append_row(
        [
          conflict.person.name,
          conflict.person.published_name,
          conflict.session.title,
          conflict.area_list.join('; '),
          FastExcel.date_num(conflict.session.start_time, conflict.session.start_time.in_time_zone.utc_offset),
          'Outside Availability'
        ],
        styles
      )
    end

    send_data workbook.read_string,
              filename: "PeopleOutSideAvailability#{Time.now.strftime('%m-%d-%Y')}.xlsx",
              disposition: 'attachment'


  end

  def set_timezone(&block)
    timezone = ConfigService.value('convention_timezone')
    Time.use_zone(timezone, &block)
  end
end
