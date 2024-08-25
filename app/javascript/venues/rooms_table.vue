<template>
  <table-vue
    :model="room"
    :columns="columns"
    :show-add="false"
    :show-settings="false"
    :show-search="false"
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
import TableVue from '../components/table_vue';
import TooltipOverflow from '../shared/tooltip-overflow';
import { room_columns as columns } from './room';
import { mapActions } from 'vuex';
import { NEW_ROOM, roomModel as room} from '../store/room.store.js';

export default {
  name: 'RoomsTable',
  components: {
    TableVue,
    TooltipOverflow
  },
  data() {
    return {
      columns,
      room
    }
  },
  methods: {
    ...mapActions({newRoom: NEW_ROOM}),
    init() {
      this.$refs['rooms-table'].fetchPaged()
    }
  // },
  // mounted() {
  //   this.init()
  }
}
</script>
