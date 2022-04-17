<template>
  <div>
    <modal-form
      title="Mass Edit State"
      ref="mass-edit-state"
      @save="onSaveMassEdit"
    >
      <!-- {{ selectedIds }} -->
      <b-form>
        <person-con-state-selector
          v-model="selectedConState"
        ></person-con-state-selector>
      </b-form>
      <template #footer="{ ok, cancel }">
        <b-button variant="link" @click="cancel()">Cancel</b-button>
        <b-button variant="primary" @click="ok()">Save</b-button>
      </template>
    </modal-form>


    <modal-form
      title="Add Person"
      ref="add-person-modal"
      @save="onSave"
    >
      <person-add
        :show-buttons='false'
        ref="add-person-form"
      ></person-add>
      <template #footer="{ ok, cancel }">
        <b-button variant="link" @click="cancel()">Cancel</b-button>
        <b-button variant="primary" @click="ok()">Save</b-button>
      </template>
    </modal-form>
    <table-vue
      @new="onNew"
      defaultSortBy='people.name'
      :model="model"
      :columns="columns"
      selectMode='multi'
      ref="people-table"
    >
      <template v-slot:alternate-search-title>Seach by Email(s)</template>
      <template v-slot:alternate-search>
        <div class="d-flex">
          <b-form-group label="Email(s)" class="w-100">
            <b-form-input
              type="text"
              v-model="searchEmails"
            ></b-form-input>
          </b-form-group>
        </div>
        <div class="d-flex">
          <b-button variant="primary" @click="onEmailSearch" class="">Search</b-button>
        </div>
      </template>

      <template v-slot:left-controls="{ selectedIds }">
        <div>
          <b-button
            variant="primary"
            @click="onEditStates(selectedIds)"
            :disabled="selectedIds.length == 0"
          >Edit State(s)
          </b-button>
        </div>
      </template>
      <template #cell(primary_email)="{ item }">
        <tooltip-overflow v-if="item.primary_email" :title="item.primary_email.email">
          {{item.primary_email.email}}
        </tooltip-overflow>
      </template>
      <template #cell(comments)="{ item }">
        <tooltip-overflow :title="item.comments">
          {{item.comments}}
        </tooltip-overflow>
      </template>
      <template #cell(current_sign_in_at)="{ item }">
        <span v-if="item.public">
          <tooltip-overflow :title="item.current_sign_in_at">
            {{new Date(item.current_sign_in_at).toLocaleDateString()}}
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
import modelUtilsMixin from "@/store/model_utils.mixin";
import PersonConStateSelector from '../components/person_con_state_selector'

export default {
  name: 'PeopleTable',
  components: {
    TableVue,
    TooltipOverflow,
    ModalForm,
    PersonAdd,
    PersonConStateSelector
  },
  mixins: [
    modelUtilsMixin
  ],
  data: () => ({
    columns,
    model,
    selectedIds: [],
    selectedConState: null,
    searchEmails: null,
  }),
  methods: {
    onEmailSearch() {
      // console.debug("FIND PEOPLE", this.searchEmails)
      let queries = {
        "op": 'any',
        "queries": []
      }
      if (this.searchEmails && this.searchEmails.length > 0) {
        let emails = this.searchEmails.split(',').map((a) => a.trim())
        queries["queries"].push(
          ["email_addresses.email","in",emails]
        )
      } else {
        queries = null
      }

      this.$refs['people-table'].setFilter(queries)
    },
    onSaveMassEdit() {
      // console.debug("*****  SAVE ME", this.selectedConState)
      if (this.selectedIds.length > 0 && this.selectedConState) {
        this.update_all('person', this.selectedIds, {con_state: this.selectedConState})
      }
    },
    onEditStates(ids) {
      this.selectedIds = ids
      this.$refs['mass-edit-state'].showModal()
    },
    onNew() {
      this.$refs['add-person-modal'].showModal()
    },
    onSave() {
      this.$refs['add-person-form'].savePerson()
    }
  }
}
</script>
