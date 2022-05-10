<template>
  <div>
    <table-vue
      @new="onNew"
      defaultSortBy='sessions.title'
      :model="model"
      :columns="columns"
      stateName="session-table-search-state"
      ref="sessions-table"
    >
      <template #cell(title)="{ item }">
        <tooltip-overflow v-if="item.title" :title="item.title">
          <span v-html="item.title"></span>
        </tooltip-overflow>
      </template>
      <template #cell(item_notes)="{ item }">
        <tooltip-overflow v-if="item.item_notes" :title="item.item_notes">
          <span v-html="item.item_notes"></span>
        </tooltip-overflow>
      </template>
      <template #cell(description)="{ item }">
        <tooltip-overflow v-if="item.description" :title="item.description">
          <span v-html="item.description"></span>
        </tooltip-overflow>
      </template>
      <!-- placeholder cols -->
      <template #cell(status)>
        <div class="text-center text-muted">&mdash;</div>
      </template>
      <template #cell(publish)>
        <div class="text-center text-muted">&mdash;</div>
      </template>
      <template #cell(visibility)>
        <div class="text-center text-muted">&mdash;</div>
      </template>
    </table-vue>
  </div>
</template>

<script>
import TableVue from '../components/table_vue';
import ModalForm from '../components/modal_form';
import TooltipOverflow from '../shared/tooltip-overflow';
import { session_columns as columns } from './session';
import { sessionModel as model } from '@/store/session.store'

export default {
  name: 'SessionTable',
  components: {
    TableVue,
    TooltipOverflow,
    ModalForm
  },
  data: () => ({
    columns,
    model
  }),
  methods: {
    onNew() {
    },
    onSave() {
    }
  },
  mounted() {
    this.$refs['sessions-table'].fetchPaged()
  }
}
</script>
