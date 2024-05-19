<template>
  <div>
    <table-vue
      :model="model"
      :columns="columns"
      ref="person-sync-table"
      stateName="person-sync-table-search-state"
    >
      <template #cell(primary_email)="{ item }">
        <tooltip-overflow v-if="item.primary_email" :title="item.primary_email.email">
          {{item.primary_email.email}}
        </tooltip-overflow>
      </template>
      <template #cell(registration_sync_data)="{ item }">
        <div v-for="reg_data in item.registration_sync_data">
          {{ reg_data.name }}
          {{ reg_data.email }}
          {{ reg_data.registration_number }}
          <pre>{{ reg_data.raw_info | pretty }}</pre>
        </div>
      </template>
    </table-vue>
</div>
</template>

<script>
import TableVue from '../components/table_vue';
import { person_sync_columns as columns } from './person_sync_columns';
import { personSyncDatumModel as model } from '@/store/person_sync_datum.store'
import TooltipOverflow from '../shared/tooltip-overflow';

export default {
  name: 'PersonSyncTable',
  components: {
    TableVue,
    TooltipOverflow
  },
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