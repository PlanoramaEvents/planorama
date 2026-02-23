export const room_columns = [
  {
    key: 'name',
    search_key: 'rooms.name',
    sortKey: 'rooms.name',
    label: 'Name',
    type: "text",
    sortable: true
  },
  {
    key: 'venue.name',
    sortKey: 'venues.name',
    label: 'Venue',
    type: "text",
    sortable: true
  },
  {
    key: 'floor',
    label: 'Floor',
    type: "text",
    sortable: true,
  },
  {
    key: 'purpose',
    label: 'Purpose',
    type: 'text',
  },
  {
    key: 'comment',
    label: 'Comment',
    type: 'text',
  },
  {
    key: 'open_for_schedule',
    label: 'Open for scheduling',
    type: "radio",
    choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
  },
  {
    key: 'is_virtual',
    label: 'Is Online',
    type: "radio",
    choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
  },
  {
    key: 'capacity',
    label: 'Capacity',
    // type: 'integer',
    sortable: true,
  },
  {
    key: 'room_set',
    label: 'Room Setup',
    type: 'text',
  }
];
