import { SESSION_STATUS, SESSION_ENVIRONMENT } from '@/constants/strings';
import AreaSelectForSearch from './area_select_for_search'
import FormatSelectForSearch from './format_select_for_search'
import RoomSelectForSearch from './room_select_for_search'

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
    operators: ['is','is not', 'is only', 'is not only', 'is empty','is not empty'],
    sortable: true,
    formatter: (value) => value && value.length ? value.join(", ") : value
  },
  {
    key: 'format.name',
    label: 'Format',
    sortKey: 'formats.name',
    sortable: true,
    component: FormatSelectForSearch,
    type: 'custom-component',
    operators: ['is','is not', 'is empty','is not empty'],
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
    type: "text"
    // todo formatter here
  },
  {
    key: 'room.name',
    label: 'Room',
    sortKey: 'rooms.name',
    sortable: true,
    // type: "text"
    component: RoomSelectForSearch,
    type: 'custom-component',
    operators: ['is','is not', 'is empty','is not empty'],
    // TODO: how would we create a select drop down for room to be fetched from server????
    // type: "select",
    // choices: roomOptionsForSearch,
  },
  {
    key: 'status',
    label: 'Status',
    formatter: (value) => SESSION_STATUS[value] || value,
    sortable: true,
    sortKey: 'status',
    choices: Object.entries(SESSION_STATUS).map(([value, label]) => ({label, value})),
    type: "select"
  },
  {
    key: 'proofed',
    label: 'Copy Edited/Proofed',
    type: "select",
    choices: [{label: "Yes", value: true}, {label: "No", value: false}],
    formatter: (value) => value ? "Yes" : "No",
    sortable: true,
  },
  {
    key: 'recorded',
    label: 'Recorded',
    type: "select",
    choices: [{label: "Yes", value: true}, {label: "No", value: false}],
    formatter: (value) => value ? "Yes" : "No",
    sortable: true
  },
  {
    key: 'streamed',
    label: 'Livestreamed',
    type: "select",
    choices: [{label: "Yes", value: true}, {label: "No", value: false}],
    formatter: (value) => value ? "Yes" : "No",
    sortable: true
  },
  {
    key: 'environment',
    label: 'Environment',
    type: "select",
    choices: Object.entries(SESSION_ENVIRONMENT).map(([value, label]) => ({label, value})),
    formatter: (value) => SESSION_ENVIRONMENT[value] || value,
  },
  {
    key: 'open_for_interest',
    label: 'Open for Interest',
    type: "select",
    choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
    formatter: (value) => value ? "Yes" : "No",
    sortable: true,
    sortKey: 'open_for_interest'
  },
  {
    key: 'require_signup',
    label: 'Requires Signup',
    type: "select",
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
    label: 'Visibility',
    formatter: (value) => value === 'is_public' ? 'Visible' : 'Not Visible',
    type: "select",
    choices: [{label: 'Visible', value: 'public'}, {label: 'Not Visible', value: 'private'}],
    sortable: true,
    sortKey: 'visibility'
  }
];
//
// TODO: ???
// :pub_reference_number
// :participant_notes
