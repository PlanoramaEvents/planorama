<template>
  <plano-modal id="add-room-modal" title="Add Room" @ok="onNew">
    <b-form-group label="Room Name">
      <b-form-input id="room-new-room-name" type="text" v-model="newRoomName"></b-form-input>
    </b-form-group>
    <b-form-group
      label="Venue"
    >
      <model-select
        id="room-venue"
        v-model="newVenueId"
        model="venue"
        field="name"
        :multiple="false"
        :selectSize="4"
      ></model-select>
    </b-form-group>
  </plano-modal>

  <table-vue
    @new="openNewModal"
    :model="room"
    :columns="columns"
    :show-add="true"
    :show-settings="false"
    ref="rooms-table"
  >
    <template #cell(name)="{ item }">
      <tooltip-overflow v-if="item.name" :title="item.name">
        {{item.name}}
      </tooltip-overflow>
    </template>
  </table-vue>
</template>

<script>
import TableVue from '@/components/table_vue';
import PlanoModal from '@/components/plano_modal.vue';
import ModelSelect from '@/components/model_select';
import TooltipOverflow from '@/components/tooltip-overflow';
import { room_columns as columns } from './room';
import { mapActions } from 'vuex';
import { NEW_ROOM, roomModel as room} from '../store/room.store';

export default {
  name: 'RoomsTable',
  components: {
    TableVue,
    TooltipOverflow,
    PlanoModal,
    ModelSelect
  },
  data() {
    return {
      columns,
      room,
      newRoomName: null,
      newVenueId: null
    }
  },
  methods: {
    ...mapActions({newRoom: NEW_ROOM}),
    openNewModal() {
      this.newRoomName = null;
      this.newVenueId = null;
      this.$bvModal.show('add-room-modal');
    },
    onNew() {
      this.newRoom({name: this.newRoomName, venue_id: this.newVenueId}).then((data) => {
        this.$router.push(`/venues/edit/room/${data.id}`)
      })
    },
    init() {
      this.$refs['rooms-table'].fetchPaged()
    }
  },
  mounted() {
    this.init();
  }
}
</script>
