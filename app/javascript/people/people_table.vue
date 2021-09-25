<template>
  <table-vuexorm
    sortField="published_name_sort_by"
    :model="Person"
    namespace="people"
  >
  </table-vuexorm>
</template>

<script>
import TableVuexorm from '../table_vuexorm';
import { Person } from './people.model';

export default {
  name: 'PeopleTable',
  data: () => ({
    Person
  }),
  components: {
    TableVuexorm,
  }
}
</script>
