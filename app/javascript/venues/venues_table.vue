<template>
  <plano-modal id="add-venue-modal" title="Add Venue" @ok="onNew">
    <b-form-group label="Venue Name">
      <b-form-input id="venue-new-venue-name" type="text" v-model="newVenueName"></b-form-input>
    </b-form-group>
  </plano-modal>
  <table-vue
    @new="openNewModal"
    :model="venue"
    :columns="columns"
    :show-add="true"
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
import TableVue from '@/components/table_vue';
import PlanoModal from '@/components/plano_modal.vue';
import TooltipOverflow from '@/components/tooltip-overflow';
import { venue_columns as columns } from './venue';
import { mapActions } from 'vuex';
import { NEW_VENUE, venueModel as venue} from '@/store/venue.store';

export default {
  name: 'VenuesTable',
  components: {
    TableVue,
    TooltipOverflow,
    PlanoModal
  },
  data() {
    return {
      columns,
      venue,
      newVenueName: null
    }
  },
  methods: {
    ...mapActions({newVenue: NEW_VENUE}),
    openNewModal() {
      this.newVenueName = null;
      this.$bvModal.show('add-venue-modal');
    },
    onNew() {
      this.newVenue({name: this.newVenueName}).then((data) => {
        this.$router.push(`/venues/edit/venue/${data.id}`)
      })
    },
    init() {
      this.$refs['venues-table'].fetchPaged()
    }
  },
  mounted() {
    this.init();
  }
}
</script>
