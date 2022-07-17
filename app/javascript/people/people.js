export const people_columns = [
  {
    key: 'published_name',
    label: 'Published Name',
    type: "text",
    sortable: true,
    class: 'col-name-field',
    stickyColumn: true
  },
  {
    key: 'name',
    label: 'Name',
    type: "text",
    sortable: true,
    class: 'col-name-field'
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
    key: 'con_state',
    search_key: 'con_state',
    label: 'Status',
    type: "select",
    // TODO: needs to be driven by settings enums
    choices: [
      {label: "not_set", value: "not_set"},
      {label: "applied", value: "applied"},
      {label: "vetted", value: "vetted"},
      {label: "wait_list", value: "wait_list"},
      {label: "invite_pending", value: "invite_pending"},
      {label: "invited", value: "invited"},
      {label: "probable", value: "probable"},
      {label: "accepted", value: "accepted"},
      {label: "declined", value: "declined"},
      {label: "rejected", value: "rejected"}
    ],
    operators: ["=", "!="],
    sortable: false
  },
  {
    key: 'attendance_type',
    label: 'Attendance Type'
  },
  {
    key: 'organization',
    label: 'Organization',
    type: "text",
    sortable: true
  },
  {
    key: 'job_title',
    label: 'Job Title',
    type: "text",
    sortable: false
  },
  // {
  //   key: 'registered',
  //   label: 'Registered',
  //   type: "radio",
  //   // TODO: how do we add dynamic choices???
  //   choices: [{label: "Yes", value: "true"}, {label: "No", value: "false"}],
  //   sortable: true
  // },
  // {
  //   key: 'registration_type',
  //   label: 'Registration Type',
  //   type: "text",
  //   sortable: true
  // },
  // {
  //   key: 'registration_number',
  //   label: 'Registration Number',
  //   type: "text",
  //   sortable: true
  // },
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
