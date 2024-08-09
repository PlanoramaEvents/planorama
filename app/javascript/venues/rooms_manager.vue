<template>
  <div>
    <div class="pb-4">
      <RoomsTable
          defaultFilter=''
          ref="rooms-table"
      ></RoomsTable>
      <rooms-sidebar></rooms-sidebar>
    </div>
  </div>
</template>


<script>
import RoomsTable from "./rooms_table";
import RoomEditor from "./room_editor";
import RoomsSidebar from "./rooms_sidebar.vue"
import modelMixin from '../store/model.mixin'
import {room_columns as columns} from "./room";

export default {
  name: "RoomsManager",
  components: {RoomEditor, RoomsTable, RoomsSidebar},
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
      // alert("in rooms_manager.selected: val="+JSON.stringify(val));
      if(val)
        this.$refs['roomEditor'].setRoomData(val);
    }
  },
  methods: {
    init() {
      this.$refs['rooms-table'].init();
    },
  }
}
</script>

<style scoped>

</style>
