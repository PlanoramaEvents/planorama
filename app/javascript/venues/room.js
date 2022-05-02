export const room_columns = [
  {
    key: 'name',
    //sortKey: 'agreements.name',
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
    type: 'boolean'
  },
  {
    key: 'is_virtual',
    label: 'Open for scheduling',
    type: Boolean
  },
  {
    key: 'length',
    label: 'Length',
    type: Number,
  },
  {
    key: 'width',
    label: 'Width',
    type: Number,
  },
  {
    key: 'height',
    label: 'Height',
    type: Number,
  },
  {
    key: 'linear_units',
    label: 'Linear Units',
    type: String,
  },
  {
    key: 'area',
    label: 'Area',
    type: Number,
    sortable: true,
  },
  {
    key: 'area_units',
    label: 'Area Units',
    type: String,
  },
  {
    key: 'capacity',
    label: 'Capacity',
    type: Number,
    sortable: true,
  },
  {
    key: 'room_set',
    label: 'Room Setup',
    type: String,
  },
];
