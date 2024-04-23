<template>
  <div>
    <bulk-edit-modal title="Edycja grupowa statusu" id="bulk-edit-status" @ok="onSaveMassEdit">
      <template #default>
        <b-form>
          <person-con-state-selector
            v-model="selectedConState"
          ></person-con-state-selector>
        </b-form>
      </template>
      <template #confirm-default>
        <p>
          Potwierdź zmianę statusu dla {{editableIds.length}} {{editableIds.length == 1 ? 'osoby' : 'osób'}} na '{{PERSON_CON_STATE[selectedConState]}}'
          <span v-if="declinedRejected">i zostaną one usunięte z poniższych sesji.</span>
        </p>
        <people-session-names :declinedRejected="declinedRejected" :ids="editableIds"></people-session-names>
      </template>
    </bulk-edit-modal>

    <modal-form
      title="Dodaj osobę"
      ref="add-person-modal"
      @save="onSave"
    >
      <person-add
        :show-buttons='false'
        ref="add-person-form"
      ></person-add>
      <template #footer="{ ok, cancel }">
        <b-button variant="link" @click="cancel()">Anuluj</b-button>
        <b-button variant="primary" @click="ok()">Zapisz</b-button>
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
      <template v-slot:alternate-search-title>Wyszukaj po adresie(e-mail)</template>
      <template v-slot:alternate-search>
        <div class="d-flex">
          <b-form-group label="Adres(e-mail)" class="w-100">
            <b-form-input
              type="text"
              v-model="searchEmails"
            ></b-form-input>
          </b-form-group>
        </div>
        <div class="d-flex">
          <b-button variant="primary" @click="onEmailSearch" class="">Szukaj</b-button>
        </div>
      </template>

      <template v-slot:left-controls="{ editableIds }">
        <div>
          <b-button
            variant="primary"
            @click="onEditStates(editableIds)"
            :disabled="editableIds.length == 0"
          >Edytuj status(y)
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
        <span v-if="item.current_sign_in_at">
          {{DateTime.fromISO(item.current_sign_in_at).toFormat("DDD, t ZZZZ")}}
        </span>
        <span v-if="!item.current_sign_in_at" class="font-italic text-muted">{{PERSON_NEVER_LOGGED_IN}}</span>
      </template>
      <template #cell(draft_approval)="{ item }">
        <div v-if="draftSchedule">
          {{ approved(item.person_schedule_approvals, 'draft') }}
        </div>
        <div v-else class="text-muted text-center"> &mdash; </div>
      </template>
      <template #cell(draft_comments)="{ item }">
        <div v-if="draftSchedule">
          <tooltip-overflow-keep-newlines :title="comments(item.person_schedule_approvals, 'draft')">
            {{ comments(item.person_schedule_approvals, 'draft') }}
          </tooltip-overflow-keep-newlines>
        </div>
        <div v-else class="text-muted text-center"> &mdash; </div>
      </template>
      <template #cell(firm_approval)="{ item }">
        <div v-if="firmSchedule">
          {{ approved(item.person_schedule_approvals, 'firm') }}
        </div>
        <div v-else class="text-muted text-center">&mdash;</div>
      </template>
      <template #cell(firm_comments)="{ item }">
        <div v-if="firmSchedule">
          <tooltip-overflow-keep-newlines :title="comments(item.person_schedule_approvals, 'firm')">
            {{ comments(item.person_schedule_approvals, 'firm') }}
          </tooltip-overflow-keep-newlines>
        </div>
        <div v-else class="text-muted text-center"> &mdash; </div>
      </template>
    </table-vue>
  </div>
</template>

<script>
import TableVue from '../components/table_vue';
import ModalForm from '../components/modal_form';
import TooltipOverflow from '../shared/tooltip-overflow';
import TooltipOverflowKeepNewlines from "@/shared/tooltip-overflow-keep-newlines";
import PersonAdd from '../people/person_add.vue';
import { people_columns as columns } from './people';
import { personModel as model } from '@/store/person.store'
import modelUtilsMixin from "@/store/model_utils.mixin";
import PersonConStateSelector from '../components/person_con_state_selector'
import PeopleSessionNames from './people_session_names';

import searchStateMixin from '../store/search_state.mixin'
import { formatPersonScheduleApprovalState } from '@/store/person_schedule_approval';
import { FETCH_WORKFLOWS, scheduleWorkflowMixin } from '@/store/schedule_workflow';
import { mapActions } from 'vuex';
import { PERSON_NEVER_LOGGED_IN, PERSON_CON_STATE } from '@/constants/strings';
import { DateTime } from 'luxon';
import BulkEditModal from '@/components/bulk_edit_modal.vue'

export default {
  name: 'PeopleTable',
  components: {
    TooltipOverflowKeepNewlines,
    TableVue,
    TooltipOverflow,
    ModalForm,
    PersonAdd,
    PersonConStateSelector,
    PeopleSessionNames,
    BulkEditModal,
  },
  mixins: [
    modelUtilsMixin,
    searchStateMixin,
    scheduleWorkflowMixin,
  ],
  data: () => ({
    columns,
    model,
    editableIds: [],
    selectedConState: null,
    searchEmails: null,
    PERSON_NEVER_LOGGED_IN,
    PERSON_CON_STATE,
    DateTime
  }),
  computed: {
    declinedRejected() {
      return this.selectedConState === "declined" || this.selectedConState === "rejected"
    }
  },
  methods: {
    ...mapActions({
      fetchScheduleWorkflows: FETCH_WORKFLOWS,
    }),
    approved(approvals, state) {
      let v = Object.values(approvals).find( o => o.workflow_state == state);
      return formatPersonScheduleApprovalState(v?.approved)
    },
    comments(approvals, state) {
      let v = Object.values(approvals).find( o => o.workflow_state == state);
      return v?.approved === 'no' ? v.comments : '';
    },
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
    onEditStates(ids) {
      this.editableIds = ids
      this.$bvModal.show('bulk-edit-status')
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

    this.$refs['people-table'].fetchPaged()
    this.fetchScheduleWorkflows();
  }
}
</script>

<style lang="scss">
.col-name-field div {
  width: 8rem;
}
</style>
