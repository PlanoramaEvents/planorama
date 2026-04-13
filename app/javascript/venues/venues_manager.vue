<template>
  <div>
    <div class="pb-4">
      <venues-table
        defaultFilter=''
        ref="venues-table"
      ></venues-table>
    </div>
    <venues-sidebar></venues-sidebar>
  </div>
</template>


<script>
import VenuesTable from "@/venues/venues_table";
import VenueEditor from "@/venues/venue_editor";
import VenuesSidebar from "@/venues/venues_sidebar.vue";
import modelMixin from '@/store/model.mixin'
import {venue_columns as columns} from "@/venues/venue";

export default {
  name: "VenuesManager",
  components: {VenueEditor, VenuesTable, VenuesSidebar},
  mixins: [
    modelMixin,
  ],
  data() {
    return {
      columns,
    }
  }
}
</script>

<style scoped>

</style>
