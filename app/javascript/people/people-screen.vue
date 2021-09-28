<template>
  <div>
    <people-table></people-table>
    <people-sidebar></people-sidebar>
  </div>
</template>

<script>
import PeopleTable from '../people/people_table.vue';
// import PeopleSidebar from '../people/people_sidebar.vue';
import { modelStore } from '../store/model.store';

export default {
  name: "PeopleScreen",
  store: modelStore,
  components: {
    PeopleTable,
  //   PeopleSidebar,
  }
}
</script>

<style>

</style>
