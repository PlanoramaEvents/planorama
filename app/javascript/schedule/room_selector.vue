<template>
  <div class="room-list">
    <b-form-checkbox
      v-model="selectAll"
      @change="onSelectAll"
      ref="select-all"
    >Select All</b-form-checkbox>
    <hr />
    <div v-for="room in rooms" :key="room.id">
      <b-form-checkbox
        v-model="selectedRooms"
        :value="room.id"
        @change="updateSelectRooms"
      >{{room.name}}</b-form-checkbox>
    </div>
  </div>
</template>

<script>
export default {
  name: "RoomSelector",
  props: {
    rooms: {
      type: Array
    }
  },
  data: () =>  ({
    selectAll: true,
    selectedRooms: []
  }),
  methods: {
    onSelectAll(v) {
      if (v) {
        this.selectedRooms = this.rooms.map((r) => r.id)
      } else {
        this.selectedRooms = []
      }

      this.$emit('change', this.selectedRooms)
    },
    updateSelectRooms() {
      this.$refs['select-all'].checked = this.selectedRooms.length == this.rooms.length
      this.$emit('change', this.selectedRooms)
    }
  },
  mounted() {
    if (this.rooms) {
      this.selectedRooms = this.rooms.map((r) => r.id)
    }
  }
}
</script>

<style lang="scss">
.room-list {
  overflow-y: scroll;
  height: 80%;
}
</style>
