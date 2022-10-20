<template>
  <div>
    <div class="pb-4">
      <RoomSetsTable
          defaultFilter=''
          ref="room-sets-table"
      ></RoomSetsTable>
    </div>
    <div class="border p-2 mb-2">
      <RoomSetEditor @saved="init"/>
    </div>
  </div>
</template>


<script>
import RoomSetsTable from "./room_sets_table";
import RoomSetEditor from "./room_set_editor";
import modelMixin from '../store/model.mixin'
import {room_set_columns as columns} from "./room_set.js";

export default {
  name: "RoomSetsManager",
  components: {RoomSetEditor, RoomSetsTable},
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
      // alert("in room_sets_manager.selected: val="+JSON.stringify(val));
      if(val)
        this.$refs.roomSetEditor.setRoomSetData(val);
    }
  },
  methods: {
    init() {
      this.$refs['room-sets-table'].init();
    },
  }
}
</script>

<style scoped>

</style>
