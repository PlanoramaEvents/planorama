export const mailing_columns = [
  {
    key: 'display_name',
    label: 'Nazwa',
    type: "text",
    sortable: true,
  },
  {
    key: 'description',
    label: 'Opis',
    type: "text",
  },
  {
    key: 'mailing_state',
    label: 'Stan',
    type: "text",
  },
  {
    key: 'date_sent',
    label: 'Data wysłania',
    sortable: true,
    formatter: (d) => (d ? new Date(d).toLocaleString() : 'n/d')
  },
  {
    key: 'sent_by.name',
    label: 'Wysłane przez',
  },
  {
    key: 'content',
    label: 'Treść',
    type: "text"
  }
]
