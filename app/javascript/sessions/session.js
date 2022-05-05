export const session_columns = [
  {
    key: 'title',
    sortKey: 'sessions.title',
    label: 'Title',
    type: "text",
    sortable: true,
    stickyColumn: true
  },
  {
    key: 'description',
    sortKey: 'sessions.description',
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
    sortKey: 'sessions.start_time',
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
    label: 'Item Notes',
    type: "text"
  },
  {
    key: 'open_for_interest',
    label: 'Open for Interest',
    type: "radio",
    choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
    sortable: false
  },
  {
    key: 'instructions_for_interest',
    label: 'Interest Instructions',
    type: "text"
  },
  {
    key: 'minimum_people',
    label: 'Min Participants'
  },
  {
    key: 'maximum_people',
    label: 'Max Participants'
  },
  {
    key: 'require_signup',
    label: 'Requires Signup',
    type: "radio",
    choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
    sortable: false
  },
  {
    key: 'waiting_list_size',
    label: 'Waiting List Size'
  },
  {
    key: 'audience_size',
    label: 'Audience Size'
  },
  {
    key: 'is_break',
    label: 'Is Break',
    type: "radio",
    choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
    sortable: false
  },
  {
    key: 'publish',
    label: 'Publish',
    type: "radio",
    choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
    sortable: false
  },
  {
    key: 'visibility',
    label: 'Visibility'
  }
];
//
// TODO: ???
// :pub_reference_number
// :participant_notes
