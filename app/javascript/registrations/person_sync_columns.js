
export const person_sync_columns = [
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
    key: 'primary_email',
    search_key: 'email_addresses.email',
    label: 'Email',
    type: "text",
    sortable: false
  },
  {
    key: 'registration_sync_data',
    label: 'Possible Match(es)',
    // Type should be JSON ...
    type: "text"
  }
]
