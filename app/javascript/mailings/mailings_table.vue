<template>
  <div>
    <table-vue
      defaultSortBy='updated_at'
      defaultSortDesc="true"
      :model="model"
      :columns="columns"
      :defaultFilter="defaultFilter"
      :show-search="false"
      :show-add="false"
      :show-settings="false"
      :show-refresh="true"
      :show-clone="true"
      :show-view="true"
      @view="$emit('view')"
      @clone="$emit('clone')"
      ref="mailings-table"
    >
      <template #cell(content)="{ item }">
        <tooltip-overflow :title="item.content">
          <div v-html="item.content"></div>
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
  props: {
    defaultFilter: null
  },
  data: () => ({
    columns,
    model
  }),
  mounted() {
    this.$refs['mailings-table'].fetchPaged()
  }
}
</script>
