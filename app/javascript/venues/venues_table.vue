<template>
  <table-vue
    :model="venue"
    :columns="columns"
    :show-add="false"
    :show-settings="false"
    ref="venues-table"
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
import { venue_columns as columns } from './venue';
import { mapActions } from 'vuex';
import { NEW_VENUE, venueModel as venue} from '../store/venue.store.js';

export default {
  name: 'VenuesTable',
  components: {
    TableVue,
    TooltipOverflow
  },
  data() {
    return {
      columns,
      venue
    }
  },
  methods: {
    ...mapActions({newVenue: NEW_VENUE}),
    init() {
      this.$refs['venues-table'].fetchPaged()
    }
  // },
  // mounted() {
  //   this.init()
  }
}
</script>
