export const room_columns = [
  {
    key: 'name',
    label: 'Nazwa',
    type: "text",
    sortable: true
  },
  {
    key: 'floor',
    label: 'Piętro',
    type: "text",
    sortable: true,
  },
  {
    key: 'purpose',
    label: 'Cel',
    type: 'text',
  },
  {
    key: 'comment',
    label: 'Komentarz',
    type: 'text',
  },
  {
    key: 'open_for_schedule',
    label: 'Otwarty do harmonogramu',
    type: "radio",
    choices: [{label: "Tak", value: "true"}, {label: "Nie", value: "false"}],
  },
  {
    key: 'is_virtual',
    label: 'Online',
    type: "radio",
    choices: [{label: "Tak", value: "true"}, {label: "Nie", value: "false"}],
  },
  {
    key: 'length',
    label: 'Długość',
    // type: 'number',
  },
  {
    key: 'width',
    label: 'Szerokość',
    // type: 'number',
  },
  {
    key: 'height',
    label: 'Wysokość',
    type: 'number',
  },
  {
    key: 'linear_units',
    label: 'Jednostki liniowe',
    type: 'text',
  },
  {
    key: 'area',
    label: 'Powierzchnia',
    // type: 'number',
    sortable: true,
  },
  {
    key: 'area_units',
    label: 'Jednostki powierzchni',
    type: 'text',
  },
  {
    key: 'capacity',
    label: 'Pojemność',
    // type: 'number',
    sortable: true,
  },
  {
    key: 'room_set',
    label: 'Ustawienie sali',
    type: 'text',
  },
];
