<template>
  <div>
    <div style="padding-bottom: 25px">
      <RoomsTable
          defaultFilter=''
      ></RoomsTable>
    </div>
    <div style="border: solid">
      Room Editor Here
      <!--RoomEditor @saved="init"/-->
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
      alert("in rooms_manager.selected: val="+JSON.stringify(val));
      // if(val)
      //   this.$refs.roomEditor.setRoomData(val);
    }
  },
  methods: {
    init() {
      this.$refs[RoomsTable].init();
    },
  }
}
</script>

<style scoped>

</style>
