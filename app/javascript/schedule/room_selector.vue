<template> 
  <div class="d-flex justify-content-end">
    <icon-button class="mt-1 mr-3" icon="gear" v-b-modal.room-selector-modal></icon-button>
    <plano-modal id="room-selector-modal" @ok="ok">
      <template #modal-title>Displayed Rooms</template>
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
    </plano-modal>
  </div>
</template>

<script>
import IconButton from '@/components/icon_button.vue';
import PlanoModal from '@/components/plano_modal.vue';


export default {
  name: "RoomSelector",
  props: {
    rooms: {
      type: Array
    }
  },
  components: {
    PlanoModal,
    IconButton
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

      // this.$emit('change', this.selectedRooms)
    },
    updateSelectRooms() {
      this.$refs['select-all'].checked = this.selectedRooms.length == this.rooms.length
      // this.$emit('change', this.selectedRooms)
    },
    ok() {
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
</style>
