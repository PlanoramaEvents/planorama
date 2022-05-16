<template>
  <div class="room-list">
    <div
      v-for="room in rooms" :key="room.id"
    >
      <b-form-checkbox
        v-model="selectedRooms"
        :value="room.id"
        @change="updateSelectRooms"
      >
        {{room.name}}
      </b-form-checkbox>
    </div>
  </div>
</template>

<script>
export default {
  name: "RoomSelector",
  components: {
  },
  mixins: [
  ],
  props: {
    rooms: {
      type: Array
    }
  },
  data: () =>  ({
    selectedRooms: []
  }),
  computed: {
  },
  methods: {
    updateSelectRooms() {
      console.debug("********* ROOMS", this.selectedRooms)
      this.$emit('change', this.selectedRooms)
    }
  },
  mounted() {
  //   //do something after mounting vue instance
  //   this.fetch_models(roomModel).then(data => {
  //     this.rooms = Object.values(data).filter(
  //       obj => (typeof obj.json === 'undefined')
  //     )
  //     this.init()
  //   })
  }
}
</script>

<style lang="scss">
.room-list {
  overflow-y: scroll;
  height: 80%;
}
</style>
