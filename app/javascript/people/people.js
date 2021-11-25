export const people_columns = [
  {
    key: 'published_name',
    label: 'Published Name',
    type: "text",
    sortable: true,
    // sortKey: 'published_name_sort_by',
    sticky: true
  },
  {
    key: 'name',
    label: 'Name',
    type: "text",
    sortable: true,
    // sortKey: 'name_sort_by',
    sticky: true
  },
  {
    key: 'pseudonym',
    label: 'Pseudonym',
    type: "text",
    // sortKey: 'pseudonym_sort_by',
    sortable: true
  },
  {
    key: 'pronouns',
    label: 'Pronouns',
    type: "text",
    sortable: false
  },
  {
    key: 'registered',
    label: 'Registered',
    type: "radio",
    // TODO: how do we add dynamic choices???
    choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
    sortable: true
  },
  {
    key: 'registration_type',
    label: 'Registration Type',
    type: "text",
    sortable: true
  },
  {
    key: 'registration_number',
    label: 'Registration Number',
    type: "text",
    sortable: true
  }
  // TODO: test for nested object
  // {
  //   field: 'bio',
  //   label: 'Bio',
  //   width: '250',
  //   searchable: false,
  //   sortable: false
  // }
];
