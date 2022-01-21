export const session_columns = [
  {
    key: 'title',
    label: 'Title',
    type: "text",
    sortable: true
  },
  {
    key: 'description',
    label: 'Description',
    type: "text",
    sortable: true
  },
  {
    key: 'format.name',
    label: 'Format',
    sortKey: 'formats.name',
    sortable: true
  },
  {
    key: 'start_time',
    label: 'Start Time',
    sortable: true
  },
  {
    key: 'duration',
    label: 'Duration'
  },
  {
    key: 'room.name',
    label: 'Room',
    sortKey: 'rooms.name',
    sortable: true
  },
  {
    key: 'item_notes',
    label: 'Item Notes'
  },
  {
    key: 'audience_size',
    label: 'Audience Size'
  },
  {
    key: 'is_break',
    label: 'Is Break'
  },
  {
    key: 'publish',
    label: 'Publish'
  },
  {
    key: 'visibility',
    label: 'Visibility'
  }
];
//
//
//            :duration, :minimum_people, :maximum_people,
//            :item_notes, :pub_reference_number, :audience_size,
//            :participant_notes, :is_break, :start_time,
//            :visibility, :publish
//
// :room,
