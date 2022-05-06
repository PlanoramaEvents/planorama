<template>
  <table-vue
    :model="roomset"
    :columns="columns"
    :show-add="false"
    :show-settings="false"
    ref="roomsets-table"
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
import { roomset_columns as columns } from './roomset';
import { mapActions } from 'vuex';
import { NEW_ROOMSET, roomsetModel as roomset} from '../store/roomset.store.js';

export default {
  name: 'RoomsetsTable',
  components: {
    TableVue,
    TooltipOverflow
  },
  data() {
    return {
      columns,
      roomset
    }
  },
  methods: {
    ...mapActions({newRoomset: NEW_ROOMSET}),
    init() {
      this.$refs['roomsets-table'].fetchPaged()
    }
  }
}
</script>
