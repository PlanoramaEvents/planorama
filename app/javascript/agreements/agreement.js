export const agreement_columns = [
  {
    key: 'title',
    sortKey: 'agreements.name',
    label: 'Title',
    type: "text",
    stickyColumn: true,
    sortable: true
  },
  {
    key: 'terms',
    label: 'Terms',
    type: "text",
    sortable: true,
  },
  {
    key: 'target',
    label: 'Target',
    type: 'text',
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
  }
];
