<template>
  <div>
    <div class="pb-4">
      <rooms-table
        defaultFilter=''
        ref="rooms-table"
      ></rooms-table>
    </div>
    <rooms-sidebar></rooms-sidebar>
  </div>
</template>


<script>
import RoomsTable from "@/venues/rooms_table";
import RoomEditor from "@/venues/room_editor";
import RoomsSidebar from "@/venues/rooms_sidebar.vue"
import modelMixin from '@/store/model.mixin'
import {room_columns as columns} from "@/venues/room";

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
  }
}
</script>

<style scoped>

</style>
