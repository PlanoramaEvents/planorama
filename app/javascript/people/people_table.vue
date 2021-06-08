<template>
  <table-vuex
    sortField="published_last_name"
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
