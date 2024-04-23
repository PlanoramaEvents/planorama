import { SESSION_STATUS, SESSION_ENVIRONMENT } from '@/constants/strings';
import AreaSelectForSearch from './area_select_for_search'
import FormatSelectForSearch from './format_select_for_search'
import RoomSelectForSearch from './room_select_for_search'

import TagsSelectForSearch from './tags_select_for_search'
import LabelsSelectForSearch from './labels_select_for_search'

export const session_columns = [
  // {
  //   key: 'id'
  // },
  {
    key: 'title',
    sortKey: 'sessions.title',
    label: 'Tytuł',
    type: "text",
    sortable: true,
    stickyColumn: true
  },
  {
    key: 'description',
    sortKey: 'sessions.description',
    label: 'Opis',
    type: "text",
    sortable: true
  },
  {
    key: 'area_list',
    sortKey: 'areas.name',
    search_key: 'area_list',
    label: 'Obszar',
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
    key: 'tag_list',
    label: 'Publiczne Tagi',
    sortable: true,
    sortKey: 'tags_list_table.tags_array',
    search_key: 'tags_list_table.tags_array',
    component: TagsSelectForSearch,
    type: 'custom-component',
    operators: ['is', 'is not', 'is only', 'is not only', 'is empty', 'is not empty'],
    formatter: (value) => value && value.length ? value.join(", ") : value
  },
  {
    key: 'label_list',
    label: 'Etykiety Administratora',
    sortable: true,
    sortKey: 'labels_list_table.labels_array',
    search_key: 'labels_list_table.labels_array',
    component: LabelsSelectForSearch,
    type: 'custom-component',
    operators: ['is', 'is not', 'is only', 'is not only', 'is empty', 'is not empty'],
    formatter: (value) => value && value.length ? value.join(", ") : value
  },
  {
    key: 'start_time',
    sortKey: 'sessions.start_time',
    label: 'Czas rozpoczęcia',
    sortable: true
  },
  {
    key: 'duration',
    label: 'Czas trwania',
    type: "text"
    // todo formatter here
  },
  {
    key: 'room.name',
    label: 'Pokój',
    sortKey: 'rooms.name',
    sortable: true,
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
    label: 'Skorygowane/Zweryfikowane',
    type: "select",
    choices: [{label: "Tak", value: true}, {label: "Nie", value: false}],
    formatter: (value) => value ? "Tak" : "Nie",
    sortable: true,
  },
  {
    key: 'recorded',
    label: 'Nagrywane',
    type: "select",
    choices: [{label: "Tak", value: true}, {label: "Nie", value: false}],
    formatter: (value) => value ? "Tak" : "Nie",
    sortable: true
  },
  {
    key: 'streamed',
    label: 'Transmitowane na żywo',
    type: "select",
    choices: [{label: "Tak", value: true}, {label: "Nie", value: false}],
    formatter: (value) => value ? "Tak" : "Nie",
    sortable: true
  },
  {
    key: 'environment',
    label: 'Środowisko',
    type: "select",
    choices: Object.entries(SESSION_ENVIRONMENT).map(([value, label]) => ({label, value})),
    formatter: (value) => SESSION_ENVIRONMENT[value] || value,
  },
  {
    key: 'open_for_interest',
    label: 'Otwarte dla zainteresowania',
    type: "select",
    choices: [{label: "Tak", value: "true"}, {label: "Nie", value: "false"}],
    formatter: (value) => value ? "Tak" : "Nie",
    sortable: true,
    sortKey: 'open_for_interest'
  },
  {
    key: 'require_signup',
    label: 'Wymaga zapisów',
    type: "select",
    choices: [{label: "Tak", value: "true"}, {label: "Nie", value: "false"}],
    formatter: (value) => value ? "Tak" : "Nie",
    sortable: true,
    sortKey: 'require_signup'
  },
  {
    key: 'publish',
    label: 'Publikuj',
    // type: "radio",
    // choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
    // sortable: false
  },
  {
    key: 'visibility',
    label: 'Widoczność',
    formatter: (value) => value === 'is_public' ? 'Widoczne' : 'Niewidoczne',
    type: "select",
    choices: [{label: 'Widoczne', value: 'public'}, {label: 'Niewidoczne', value: 'private'}],
    sortable: true,
    sortKey: 'visibility'
  },
  {
    key: 'created_at',
    label: 'Data utworzenia',
    sortKey: 'sessions.created_at',
    sortable: true
  },
  {
    key: 'updated_at',
    label: 'Data aktualizacji',
    sortKey: 'sessions.updated_at',
    sortable: true
  },
  {
    key: 'updated_by',
    label: 'Aktualizowane przez',
    sortable: false
  }
];
//
// TODO: ???
// :pub_reference_number
// :participant_notes
