<template>
  <div>
    <modal-form
      title="Add Person"
      ref="add-person-modal"
    >
      <person-add
        :show-buttons='false'
      ></person-add>
    </modal-form>
    <table-vue
      @new="onNew"
      defaultSortBy='name'
      :model="model"
      :columns="columns"
    >
      <template #cell(primary_email)="{ item }">
        <tooltip-overflow :title="item.primary_email.email">
          {{item.primary_email.email}}
        </tooltip-overflow>
      </template>
      <template #cell(comments)="{ item }">
        <tooltip-overflow :title="item.comments">
          {{item.comments}}
        </tooltip-overflow>
      </template>
      <template #cell(last_sign_in_at)="{ item }">
        <span v-if="item.public">
          <tooltip-overflow :title="item.last_sign_in_at">
            {{new Date(item.last_sign_in_at).toLocaleDateString()}}
          </tooltip-overflow>
        </span>
      </template>
    </table-vue>
  </div>
</template>

<script>
import TableVue from '../components/table_vue';
import ModalForm from '../components/modal_form';
import TooltipOverflow from '../shared/tooltip-overflow';
import PersonAdd from '../people/person_add.vue';
import { people_columns as columns } from './people';
import { personModel as model } from '@/store/person.store'

export default {
  name: 'PeopleTable',
  components: {
    TableVue,
    TooltipOverflow,
    ModalForm,
    PersonAdd
  },
  data: () => ({
    columns,
    model
  }),
  methods: {
    onNew() {
      this.$refs['add-person-modal'].showModal()
    }
  }
}
</script>
