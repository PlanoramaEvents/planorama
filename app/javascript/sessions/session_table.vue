<template>
  <div>
    <modal-form
      title="Bulk Edit Status"
      ref="mass-edit-state"
      @save="onConfirmMassEdit"
    >
      <b-form>
        <session-state-selector
          v-model="selectedSessionState"
        ></session-state-selector>
      </b-form>
      <template #footer="{ ok, cancel }">
        <b-button variant="link" @click="cancel()">Cancel</b-button>
        <b-button variant="primary" @click="ok()">Save</b-button>
      </template>
    </modal-form>

    <modal-form
      title="Bulk Edit Status Confirmation"
      ref="mass-edit-confirm"
      @save="onSaveMassEdit"
    >
      <p>
        Please confirm that you want to change the
        status of {{editableIds.length}} {{editableIds.length == 1 ? 'session' : 'sessions'}} to '{{selectedSessionState}}'
      </p>
      <template #footer="{ ok, cancel }">
        <b-button variant="link" @click="cancel()">Cancel</b-button>
        <b-button variant="primary" @click="ok()">Save</b-button>
      </template>
    </modal-form>

    <table-vue
      @new="openNewModal"
      defaultSortBy='sessions.title'
      :model="model"
      :columns="columns"
      stateName="session-table-search-state"
      selectMode='multi'
      ref="sessions-table"
    >
      <template v-slot:left-controls="{ editableIds }">
        <div>
          <b-button
            variant="primary"
            @click="onEditStates(editableIds)"
            :disabled="editableIds.length == 0"
          >Edit Status(es)
          </b-button>
        </div>
      </template>

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
      <template #cell(area_list)="{ item }">
        <tooltip-overflow v-if="item.area_list" :title="formatAreas(item.area_list)">
          <span>{{formatAreas(item.area_list)}}</span>
        </tooltip-overflow>
      </template>
      <template #cell(start_time)="{ item }">
        <span v-if="item.start_time">
          <tooltip-overflow :title="formatLocaleDate(item.start_time)">
            {{formatLocaleDate(item.start_time)}}
          </tooltip-overflow>
        </span>
      </template>
      <!-- placeholder cols -->
      <template #cell(publish)>
        <div class="text-center text-muted">&mdash;</div>
      </template>
    </table-vue>
    <plano-modal id="add-session" title="Add Session" @ok="onNew">
      <b-form-group label="Session Title">
        <b-form-input id="session-new-session-title" type="text" v-model="newSessionTitle"></b-form-input>
      </b-form-group>
    </plano-modal>
  </div>
</template>

<script>
import TableVue from '../components/table_vue';
import ModalForm from '../components/modal_form';
import TooltipOverflow from '../shared/tooltip-overflow';
import { session_columns as columns } from './session';
import { NEW_SESSION, sessionModel as model } from '@/store/session.store'
import dateTimeMixin from '../components/date_time.mixin'
import { areaMixin } from './session_fields.mixin';
import PlanoModal from '@/components/plano_modal.vue';
import { mapActions } from 'vuex';
import { SESSION_STATUS, SESSION_MUST_UNSCHEDULE } from '@/constants/strings';
import modelUtilsMixin from "@/store/model_utils.mixin";

import SessionStateSelector from '../components/session_state_selector'

export default {
  name: 'SessionTable',
  components: {
    TableVue,
    TooltipOverflow,
    ModalForm,
    PlanoModal,
    SessionStateSelector
  },
  mixins: [
    dateTimeMixin,
    modelUtilsMixin,
    areaMixin
  ],
  data: () => ({
    SESSION_STATUS,
    columns,
    model,
    editableIds: [],
    selectedSessionState: null,
    newSessionTitle: null
  }),
  methods: {
    ...mapActions({
      newSession: NEW_SESSION
    }),
    openNewModal() {
      this.newSessionTitle = null;
      this.$root.$emit('bv::show::modal', 'add-session');
    },
    onNew() {
      this.newSession({title: this.newSessionTitle}).then((data) => {
        this.$router.push(`/sessions/edit/${data.id}`)
      })
    },
    onSaveMassEdit() {
      if (this.editableIds.length > 0 && this.selectedSessionState) {
        this.update_all('session', this.editableIds, {status: this.selectedSessionState})
      }
    },
    onConfirmMassEdit() {
      this.$refs['mass-edit-confirm'].showModal()
    },
    onEditStates(ids) {
      this.editableIds = ids
      this.$refs['mass-edit-state'].showModal()
    },
    onSave() {
    }
  },
  mounted() {
    this.$refs['sessions-table'].fetchPaged()
  }
}
</script>
