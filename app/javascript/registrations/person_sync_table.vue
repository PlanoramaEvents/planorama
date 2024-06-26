<template>
  <div>
    <table-vue
      :model="model"
      :columns="columns"
      ref="person-sync-table"
      stateName="person-sync-table-search-state"
      :showControls="false"
      stickyHeader="450px"
      :showBottomControls="false"
    >
    <template #left-controls="{total}">
      <div>
        <div>Last completed full sync: {{ lastSync }}</div>
        <div>People with potential matches: <strong>{{ total }}</strong></div>
      </div>
    </template>
      <template #cell(primary_email)="{ item }">
        <tooltip-overflow v-if="item.primary_email" :title="item.primary_email.email">
          {{item.primary_email.email}}
        </tooltip-overflow>
      </template>
      <template #head(registration_sync_data)="{ label }">
        <div class="d-flex justify-content-between">
        <span>{{ label }}</span>
        <span class="mr-3 pr-3">Actions</span>
        </div>
      </template>
      <template #cell(registration_sync_data)="{ item }">
        <div v-for="(reg_data, _, index) in item.registration_sync_data" :key="reg_data.id">
          <div v-if="index !== 0" style="border-bottom: 1px solid black" class="w-75 my-3"></div>
          <div class="d-flex justify-content-between">
            <div>
          <display-sync-data :regData="reg_data"></display-sync-data>
          </div>
          <div class="d-flex flex-column justify-content-center mr-3"> 
            <b-button variant="primary">Match</b-button>
            <b-button variant="primary" class="mt-2">Dismiss</b-button>
          </div>
          </div>
        </div>
      </template>
    </table-vue>
</div>
</template>

<script>
import TableVue from '../components/table_vue.vue';
import { person_sync_columns as columns } from './person_sync_columns';
import { personSyncDatumModel as model } from '@/store/person_sync_datum.store'
import TooltipOverflow from '../shared/tooltip-overflow.vue';
import DisplaySyncData from './display_sync_data.vue';
import { registrationSyncStatsMixin } from '@/store/registration_sync_stats.mixin';

export default {
  name: 'PersonSyncTable',
  components: {
    TableVue,
    TooltipOverflow,
    DisplaySyncData,
  },
  mixins: [registrationSyncStatsMixin],
  data: () => ({
    columns,
    model
  }),
  filters: {
    pretty: function (value) {
      return JSON.stringify(value, null, 2);
    }
  },
  methods: {
    personLink(id) {
      return `/#/people/edit/${id}`;
    }
  },
  mounted() {
    this.$refs['person-sync-table'].fetchPaged()
  }
}
</script>
