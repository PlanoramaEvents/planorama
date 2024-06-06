<template>
  <div>
    <table-vue
      defaultSortBy='name'
      :model="model"
      :columns="columns"
      ref="registration-sync-table"
      stateName="registration-sync-table-search-state"
    >
      <template #cell(raw_info)="{ item }">
        <pre>{{ item.raw_info | pretty }}</pre>
      </template>
      <template #cell(people)="{ item }">
        <div v-for="person in item.people" :key="person.id">
          <a :href="personLink(person.id)">{{ person.name }}</a>
        </div>
      </template>
    </table-vue>
</div>
</template>

<script>
import TableVue from '../components/table_vue';
import { registration_sync_columns as columns } from './registration_sync_columns';
import { registrationSyncDatumModel as model } from '@/store/registration_sync_datum.store'
import TooltipOverflow from '../shared/tooltip-overflow';

export default {
  name: 'RegistrationSyncTable',
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
    this.$refs['registration-sync-table'].fetchPaged()
  }
}
</script>
