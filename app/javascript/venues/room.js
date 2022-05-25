export const room_columns = [
  {
    key: 'name',
    label: 'Name',
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
    label: 'Is Virtual',
    type: "radio",
    choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
  },
  {
    key: 'is_virtual',
    label: 'Length',
    // type: 'number',
  },
  {
    key: 'width',
    label: 'Width',
    // type: 'number',
  },
  {
    key: 'height',
    label: 'Height',
    type: 'number',
  },
  {
    key: 'linear_units',
    label: 'Linear Units',
    type: 'text',
  },
  {
    key: 'area',
    label: 'Area',
    // type: 'number',
    sortable: true,
  },
  {
    key: 'area_units',
    label: 'Area Units',
    type: 'text',
  },
  {
    key: 'capacity',
    label: 'Capacity',
    // type: 'number',
    sortable: true,
  },
  {
    key: 'room_set',
    label: 'Room Setup',
    type: 'text',
  },
];
