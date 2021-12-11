<template>
  <div>
    <table-vue
      defaultSortBy='title'
      :model="model"
      :columns="columns"
    >
      <template #cell(content)="{ item }">
        <tooltip-overflow :title="item.content">
          {{item.content}}
        </tooltip-overflow>
      </template>
    </table-vue>
  </div>
</template>

<script>
import TableVue from '../components/table_vue';
import TooltipOverflow from '../shared/tooltip-overflow';
import { mailing_columns as columns } from './mailing';
import { mailingModel as model } from '@/store/mailing.store'

export default {
  name: 'MailingsTable',
  components: {
    TableVue,
    TooltipOverflow
  },
  data: () => ({
    columns,
    model
  }),
  methods: {
    // onNew() {
    //   this.$refs['add-person-modal'].showModal()
    // }
  }
}
</script>
