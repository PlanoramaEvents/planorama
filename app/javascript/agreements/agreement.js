export const agreement_columns = [
  {
    key: 'title',
    //sortKey: 'agreements.name',
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
    key: 'created_at',
    label: 'Published On',
    sortable: true,
    formatter: (d) => new Date(d).toLocaleDateString()
  }
];
