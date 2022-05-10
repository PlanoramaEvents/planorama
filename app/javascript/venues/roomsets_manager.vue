<template>
  <div>
    <div style="padding-bottom: 25px">
      <RoomsetsTable
          defaultFilter=''
          ref="room-sets-table"
      ></RoomsetsTable>
    </div>
    <div style="border: solid">
      <RoomsetEditor @saved="init" ref="roomsetEditor"/>
    </div>
  </div>
</template>


<script>
import RoomsetsTable from "./roomsets_table";
import RoomsetEditor from "./roomset_editor";
import modelMixin from '../store/model.mixin'
import {roomset_columns as columns} from "./roomset.js";

export default {
  name: "RoomsManager",
  components: {RoomsetEditor, RoomsetsTable},
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
        this.$refs['roomsetEditor'].setRoomsetData(val);
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
