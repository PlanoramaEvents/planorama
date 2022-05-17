import AreaSelectForSearch from './area_select_for_search'

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
    key: 'area_list',
    sortKey: 'areas.name',
    search_key: 'areas.name',
    label: 'Area',
    component: AreaSelectForSearch,
    type: 'custom-component',
    operators: ['is','is not','is empty','is not empty'], // 'is only', 'is not only' (same as is)
    sortable: true,
    formatter: (value) => value && value.length ? value.join(", ") : value
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
    label: 'Duration',
    // todo formatter here
  },
  {
    key: 'room.name',
    label: 'Room',
    sortKey: 'rooms.name',
    sortable: true
  },
  {
    key: 'status',
    label: 'Status',
  },
  {
    key: 'open_for_interest',
    label: 'Open for Interest',
    type: "radio",
    choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
    formatter: (value) => value ? "Yes" : "No"
  },
  {
    key: 'require_signup',
    label: 'Requires Signup',
    type: "radio",
    choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
    formatter: (value) => value ? "Yes" : "No"
  },
  {
    key: 'publish',
    label: 'Publish',
    // type: "radio",
    // choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
    // sortable: false
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
