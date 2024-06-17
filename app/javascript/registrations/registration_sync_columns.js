
export const registration_sync_columns = [
  {
    key: 'name',
    label: 'Name',
    type: "text"
  },
  {
    key: 'registration_number',
    label: 'Registration Number',
    type: "text"
  },
  // {
  //   key: 'reg_id',
  //   label: 'Registration Id',
  //   type: "text"
  // },
  {
    key: 'email',
    label: 'Email',
    type: "text"
  },
  {
    key: 'raw_info',
    label: 'Raw Info',
    // Type should be JSON ...
    type: "text"
  },
  // TODO: list of people
  {
    key: 'people',
    label: 'Possible Match(es)',
    // Type should be JSON ...
    type: "text"
  }
]
