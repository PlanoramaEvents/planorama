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
    formatter: (d) => (d ? new Date(d).toLocaleString() : 'n/a')
  },
  {
    key: 'sent_by.name',
    label: 'Sent By',
  },
  {
    key: 'content',
    label: 'Content',
    type: "text"
  }
]
