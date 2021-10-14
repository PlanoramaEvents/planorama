<template>
  <div>
    <people-table></people-table>
    <people-sidebar model="person"></people-sidebar>
  </div>
</template>

<script>
import PeopleTable from './people_table.vue';
import PeopleSidebar from './people_sidebar.vue';

export default {
  name: "PeopleScreen",
  components: {
    PeopleTable,
    PeopleSidebar,
  }
}
</script>

<style>

</style>
