import { SESSION_STATUS } from '@/constants/strings';
import AreaSelectForSearch from './area_select_for_search'

export const session_columns = [
  // {
  //   key: 'id'
  // },
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
    search_key: 'area_list',
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
    formatter: (value) => SESSION_STATUS[value] || value,
    sortable: true,
    sortKey: 'status',
    choices: ['draft', 'reviewed', 'revised', 'dropped'].map(value => ({label: SESSION_STATUS[value], value})),
    type: "select"
  },
  {
    key: 'open_for_interest',
    label: 'Open for Interest',
    type: "radio",
    choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
    formatter: (value) => value ? "Yes" : "No",
    sortable: true,
    sortKey: 'open_for_interest'
  },
  {
    key: 'require_signup',
    label: 'Requires Signup',
    type: "radio",
    choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
    formatter: (value) => value ? "Yes" : "No",
    sortable: true,
    sortKey: 'require_signup'
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
