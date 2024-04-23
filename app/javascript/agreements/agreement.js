export const agreement_columns = [
  {
    key: 'title',
    //sortKey: 'agreements.name',
    label: 'Tytuł',
    type: "text",
    sortable: true
  },
  {
    key: 'terms',
    label: 'Treść',
    type: "text",
    sortable: true,
  },
  {
    key: 'agreement_type',
    label: 'Typ Umowy',
    type: 'text',
    sortable: true,
  },
  {
    key: 'target',
    label: 'Cel',
    type: 'text',
    sortable: true,
  },
  {
    key: 'created_at',
    label: 'Opublikowano',
    sortable: true,
    formatter: (d) => new Date(d).toLocaleString()
  }
];
