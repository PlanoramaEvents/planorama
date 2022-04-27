<template>
  <div>
    <modal-form
      title="Mass Edit State"
      ref="mass-edit-state"
      @save="onConfirmMassEdit"
    >
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
      title="Mass Edit State Confirmation"
      ref="mass-edit-confirm"
      @save="onSaveMassEdit"
    >
      <p>
        Please confirm that you want to change the
        status of {{editableIds.length}} {{editableIds.length == 1 ? 'person' : 'people'}}
      </p>
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
      stateName="people-table-search-state"
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

      <template v-slot:left-controls="{ editableIds }">
        <div>
          <b-button
            variant="primary"
            @click="onEditStates(editableIds)"
            :disabled="editableIds.length == 0"
          >Edit State(s)
          </b-button>
        </div>
      </template>
      <template #cell(pronouns)="{ item }">
        <tooltip-overflow v-if="item.pronouns" :title="item.pronouns">
          {{item.pronouns}}
        </tooltip-overflow>
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
            {{new Date(item.current_sign_in_at).toLocaleString()}}
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

import searchStateMixin from '../store/search_state.mixin'

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
    modelUtilsMixin,
    searchStateMixin
  ],
  data: () => ({
    columns,
    model,
    editableIds: [],
    selectedConState: null,
    searchEmails: null,
  }),
  methods: {
    queries(searchEmails) {
      let queries = {
        "op": 'any',
        "queries": []
      }
      if (searchEmails && searchEmails.length > 0) {
        let emails = searchEmails.split(',').map((a) => a.trim())
        queries["queries"].push(
          ["email_addresses.email","in",emails]
        )
      } else {
        queries = null
      }
      return queries
    },
    onEmailSearch() {
      if (this.searchEmails) {
        this.setSearchState({
          key: 'people-table-search-state',
          setting: {
            emails: this.searchEmails
          }
        })
      } else {
        this.setSearchState({
          key: 'people-table-search-state',
          setting: {}
        })
      }
      this.$refs['people-table'].setFilter(this.queries(this.searchEmails))
    },
    onSaveMassEdit() {
      if (this.editableIds.length > 0 && this.selectedConState) {
        this.update_all('person', this.editableIds, {con_state: this.selectedConState})
      }
    },
    onConfirmMassEdit() {
      this.$refs['mass-edit-confirm'].showModal()
    },
    onEditStates(ids) {
      this.editableIds = ids
      this.$refs['mass-edit-state'].showModal()
    },
    onNew() {
      this.$refs['add-person-modal'].showModal()
    },
    onSave() {
      this.$refs['add-person-form'].savePerson()
    }
  },
  mounted() {
    let saved = this.getSearchState()('people-table-search-state')
    let peopleTable = this.$refs['people-table']
    if (saved) {
      if (saved.emails) {
        this.searchEmails = saved.emails
        this.$refs['people-table'].setFilter(this.queries(this.searchEmails))
        this.$root.$emit('bv::toggle::collapse', 'advanced-search')
      }
    }

    this.$root.$on('bv::collapse::state', (collapseId, isJustShown) => {
      if (collapseId == 'advanced-search' && isJustShown && saved && saved.emails && peopleTable) {
        peopleTable.showAlternateSearch()
      }
    })
  }
}
</script>

<style>
.col-name-field div {
  width: 8rem;
}
</style>
