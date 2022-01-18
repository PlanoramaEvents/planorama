export const survey_columns = [
  {
    key: 'name',
    sortKey: 'surveys.name',
    label: 'Name',
    type: "text",
    stickyColumn: true,
    sortable: true
  },
  {
    key: 'description',
    label: 'Description',
    type: "text",
    sortable: true,
  },
  {
    key: 'public',
    label: 'Status',
    formatter: (p) => p ? 'Published' : 'Closed',
    sortable: true,
  },
  {
    key: 'published_on',
    label: 'Published On',
    sortable: true,
  },
  {
    key: 'updated_at',
    label: 'Last Modified On',
    sortable: true,
    formatter: (d) => new Date(d).toLocaleDateString()
  },
  {
    key: 'updated_by.name',
    label: 'Last Modified By',
    sortable: true
  },
  'preview',
  'surveyLink',
  // welcome
  // thank_you
  // submit_string
  // use_captcha
  // public
  // transition_acceptance_status
  // transition_decline_status
  // declined_msg
  // anonymous
];
