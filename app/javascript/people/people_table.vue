<template>
  <table-vuex
    sortField="sort_by"
    :modelType="modelType"
  >
  </table-vuex>
</template>

<script>
import TableVuex from '../table_vuex';
import { Person } from './people';

export default {
  name: 'PeopleTable',
  data: () => ({
    modelType: Person
  }),
  components: {
    TableVuex,
  }
}
</script>
