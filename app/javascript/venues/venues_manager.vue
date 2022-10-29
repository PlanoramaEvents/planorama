<template>
  <div>
    <div class="pb-4">
      <VenuesTable
          defaultFilter=''
          ref="venues-table"
      ></VenuesTable>
    </div>
    <div class="border p-2 mb-2">
      <VenueEditor @saved="init" ref="venueEditor"/>
    </div>
  </div>
</template>


<script>
import VenuesTable from "./venues_table";
import VenueEditor from "./venue_editor";
import modelMixin from '../store/model.mixin'
import {venue_columns as columns} from "./venue.js";

export default {
  name: "VenuesManager",
  components: {VenueEditor, VenuesTable},
  mixins: [
    modelMixin,
  ],
  data() {
    return {
      columns,
    }
  },
  watch: {
    "selected" : function(val) {
      // alert("in venues_manager.selected: val="+JSON.stringify(val));
      if(val)
        this.$refs['venueEditor'].setVenueData(val);
    }
  },
  methods: {
    init() {
      this.$refs['venues-table'].init();
    },
  }
}
</script>

<style scoped>

</style>
