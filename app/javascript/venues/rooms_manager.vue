<template>
  <div class="scrollable">
    <RoomsTable
        defaultFilter=''
        ref="rooms-table"
    ></RoomsTable>
    <!--RoomEditor @saved="init" ref="roomEditor"/-->
    <RoomSidebar @saved="init" ref="roomEditor"></RoomSidebar>
  </div>
</template>


<script>
import RoomsTable from "./rooms_table";
import RoomEditor from "./room_editor";
import RoomSidebar from "./room_sidebar";
// import modelMixin from '../store/model.mixin'
// import {room_columns as columns} from "./room";

export default {
  name: "RoomsManager",
  components: {RoomSidebar, RoomEditor, RoomsTable},
  // mixins: [
  //   modelMixin,
  // ],
  // data() {
  //   return {
  //     columns,
  //   }
  // },
  // watch: {
  //   "selected" : function(val) {
  //     // alert("in rooms_manager.selected: val="+JSON.stringify(val));
  //     if(val)
  //       this.$refs['roomEditor'].setRoomData(val);
  //   }
  // },
  methods: {
    init() {
      this.$refs['rooms-table'].init();
    },
  }
}
</script>

<style scoped>

</style>
