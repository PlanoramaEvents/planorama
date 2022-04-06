export const people_columns = [
  {
    key: 'published_name',
    label: 'Published Name',
    type: "text",
    sortable: true,
    // sortKey: 'published_name_sort_by',
    // stickyColumn: true,
  },
  {
    key: 'name',
    label: 'Name',
    type: "text",
    sortable: true,
    // stickyColumn: true
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
    key: 'primary_email',
    search_key: 'email_addresses.email',
    label: 'Email',
    type: "text",
    sortable: false
  },
  {
    key: 'organization',
    label: 'Organization',
    type: "text",
    sortable: true
  },
  {
    key: 'job_title',
    label: 'Job Ttile',
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
  },
  {
    key: 'gender',
    label: 'Gender',
    type: "text",
    sortable: false
  },
  {
    key: 'opted_in',
    label: 'Opted In',
    type: "radio",
    choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
    sortable: false
  },
  {
    key: 'con_state',
    label: 'Status',
    // type: "radio",
    // choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
    sortable: false
  },
  {
    key: 'comments',
    label: 'Comments',
    type: "text",
    sortable: false
  },
  {
    key: 'current_sign_in_at',
    label: 'Signed In At',
    sortable: false
  }
];
