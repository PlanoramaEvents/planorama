<template>
  <div>
    <div class="pb-4">
      <RoomsTable
          defaultFilter=''
          ref="rooms-table"
      ></RoomsTable>
    </div>
    <div class="border p-2 mb-2">
      <RoomEditor @saved="init" ref="roomEditor"/>
    </div>
  </div>
</template>


<script>
import RoomsTable from "./rooms_table";
import RoomEditor from "./room_editor";
import modelMixin from '../store/model.mixin'
import {room_columns as columns} from "./room";

export default {
  name: "RoomsManager",
  components: {RoomEditor, RoomsTable},
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
