<template>
  <div class="mb-3">
    <people-table></people-table>
    <people-sidebar :model="model"></people-sidebar>
  </div>
</template>

<script>
import PeopleTable from './people_table.vue';
import PeopleSidebar from './people_sidebar.vue';
import { personModel as model } from '../store/person.store';
export default {
  name: "PeopleList",
  data: () => ({
    model
  }),
  components: {
    PeopleTable,
    PeopleSidebar
  }
}
</script>

<style>
</style>
