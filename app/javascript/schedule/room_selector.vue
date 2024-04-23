<template> 
  <div>
    <icon-button class="mt-1 mr-3" icon="gear" v-b-modal.room-selector-modal></icon-button>
    <plano-modal id="room-selector-modal" @ok="ok" @show="show">
      <template #modal-title>Pokazane Sale</template>
      <div class="room-list">
        <b-form-checkbox
          v-model="selectAll"
          @change="onSelectAll"
          ref="select-all"
        >Wybierz wszystkie</b-form-checkbox>
        <hr />
        <div v-for="room in collection" :key="room.id">
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
import { modelMixinNoProp } from '@/store/model.mixin';
import { mapMutations, mapState } from 'vuex';
import { SET_ROOMS_FOR_SCHEDULING } from '@/store/room.store';



export default {
  name: "RoomSelector",
  mixins: [
    modelMixinNoProp
  ],
  components: {
    PlanoModal,
    IconButton
  },
  data: () =>  ({
    selectAll: true,
    model: 'room',
    selectedRooms: [],
  }),
  computed: {
    ...mapState(['roomsForScheduling']),
  },
  methods: {
    ...mapMutations({
      setRoomsForScheduling: SET_ROOMS_FOR_SCHEDULING
    }),
    onSelectAll(v) {
      if (v) {
        this.selectedRooms = this.collection.map((r) => r.id)
      } else {
        this.selectedRooms = []
      }

    },
    updateSelectRooms() {
      this.selectAll = this.selectedRooms?.length === this.collection?.length
    },
    ok() {
      this.setRoomsForScheduling(this.selectedRooms);
    },
    show() {
      this.selectedRooms = this.roomsForScheduling;
      this.updateSelectRooms();
    }
  },
}
</script>

<style lang="scss">
</style>
