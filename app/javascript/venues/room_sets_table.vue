<template>
  <table-vue
    :model="roomSetModel"
    :columns="columns"
    :show-add="false"
    :show-settings="false"
    ref="room-sets-table"
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
import { room_set_columns as columns } from './room_set';
import { mapActions } from 'vuex';
import { NEW_ROOMSET, roomSetModel as roomSetModel} from '../store/room_set.store.js';

export default {
  name: 'RoomSetsTable',
  components: {
    TableVue,
    TooltipOverflow
  },
  data() {
    return {
      columns,
      roomSetModel
    }
  },
  methods: {
    ...mapActions({newRoomSet: NEW_ROOMSET}),
    init() {
      this.$refs['room-sets-table'].fetchPaged()
    }
  }
}
</script>
