<template>
  <div>
    <button type="button" class="btn btn-secondary btn-sm" @click="getPeople">
      GET PEOPLE
    </button>

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
  },
  methods: {
    getPeople() {
      // console.debug('******** GET PEOPLE CALLED: ', this.$store)
      this.$store.dispatch('jv/get', 'people').then((data) => {
        console.log('****', data._jv.json.meta)
        // console.log(data['0beae1ed-fddc-409e-a702-52d5da654519'].bio)
      })
    }
  }
}
</script>

<style>

</style>
