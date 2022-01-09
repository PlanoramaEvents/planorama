export const mailing_columns = [
  {
    key: 'display_name',
    label: 'Name',
    type: "text",
    sortable: true,
  },
  {
    key: 'description',
    label: 'Description',
    type: "text",
  },
  {
    key: 'mailing_state',
    label: 'Status',
    type: "text",
  },
  {
    key: 'date_sent',
    label: 'Date Sent',
    sortable: true,
    formatter: (d) => (d ? new Date(d).toLocaleDateString() : 'n/a')
  },
  {
    key: 'content',
    label: 'Content',
    type: "text"
  },
  // TODO: add sent by
  // {
  //   key: 'sent_by',
  //   label: 'Sent By',
  //   type: "text",
  // }
]
