export const survey_columns = [
  {
    key: 'name',
    sortKey: 'surveys.name',
    label: 'Nazwa',
    type: "text",
    stickyColumn: true,
    sortable: true
  },
  {
    key: 'description',
    sortKey: 'surveys.description',
    label: 'Opis',
    type: "text",
    sortable: true,
  },
  {
    key: 'public',
    sortKey: 'surveys.public',
    label: 'Status',
    formatter: (p) => p ? 'Opublikowany' : 'Zamknięty',
    sortable: true,
  },
  {
    key: 'nbr_submissions',
    label: 'Liczba odpowiedzi',
    sortable: false    
  },
  {
    key: 'published_on',
    sortKey: 'surveys.published_on',
    label: 'Data publikacji',
    sortable: true,
  },
  {
    key: 'updated_at',
    sortKey: 'surveys.updated_at',
    label: 'Ostatnio zmodyfikowany',
    sortable: true,
    formatter: (d) => new Date(d).toLocaleString()
  },
  {
    key: 'updated_by.name',
    label: 'Ostatnio zmodyfikowany przez',
    sortable: false
  },
  'preview',
  //'surveyLink',
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
