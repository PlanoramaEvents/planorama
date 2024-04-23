<template>
  <div>
    <bulk-edit-modal id="bulk-edit-status" title="Edycja masowa statusów" @ok="onSaveMassEdit">
      <template #default>
        <b-form-select :options="sessionStatusOptionsNoDropped"
          v-model="selectedSessionState"
        ></b-form-select>
      </template>
      <template #confirm-default>
        <p>
          Potwierdź zmianę statusu {{editableIds.length}} {{editableIds.length == 1 ? 'session' : 'session'}} na '{{SESSION_STATUS[selectedSessionState]}}'
        </p>
      </template>
    </bulk-edit-modal>

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
          >Edytuj status(y)
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
      <template #cell(tag_list)="{ item }">
        <tooltip-overflow v-if="item.tag_list" :title="formatTags(item.tag_list)">
          <span>{{formatTags(item.tag_list)}}</span>
        </tooltip-overflow>
      </template>
      <template #cell(label_list)="{ item }">
        <tooltip-overflow v-if="item.label_list" :title="formatTags(item.label_list)">
          <span>{{ formatTags(item.label_list) }}</span>
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
      <template #cell(created_at)="{ item }">
        <span v-if="item.created_at">
          <tooltip-overflow :title="formatLocaleDate(item.created_at)">
            {{ formatLocaleDate(item.created_at) }}
          </tooltip-overflow>
        </span>
      </template>
      <template #cell(updated_at)="{ item }">
        <span v-if="item.updated_at">
          <tooltip-overflow :title="formatLocaleDate(item.updated_at)">
            {{ formatLocaleDate(item.updated_at) }}
          </tooltip-overflow>
        </span>
      </template>
      <template #cell(publish)>
        <div class="text-center text-muted">&mdash;</div>
      </template>
    </table-vue>
    <plano-modal id="add-session" title="Dodaj sesję" @ok="onNew">
    <b-form-group label="Tytuł sesji">
      <b-form-input id="session-new-session-title" type="text" v-model="newSessionTitle"></b-form-input>
    </b-form-group>
  </plano-modal>
  </div>
</template>

<script>
import TableVue from '../components/table_vue';
import TooltipOverflow from '../shared/tooltip-overflow';
import { session_columns as columns } from './session';
import { NEW_SESSION, sessionModel as model } from '@/store/session.store'
import dateTimeMixin from '../components/date_time.mixin'
import { areaMixin, sessionStatusMixin } from './session_fields.mixin';
import PlanoModal from '@/components/plano_modal.vue';
import { mapActions } from 'vuex';
import { SESSION_STATUS, SESSION_MUST_UNSCHEDULE } from '@/constants/strings';
import modelUtilsMixin from "@/store/model_utils.mixin";
import BulkEditModal from '@/components/bulk_edit_modal.vue';
import { tagsMixin } from '@/store/tags.mixin';

export default {
  name: 'SessionTable',
  components: {
    TableVue,
    TooltipOverflow,
    PlanoModal,
    BulkEditModal
  },
  mixins: [
    dateTimeMixin,
    modelUtilsMixin,
    areaMixin,
    sessionStatusMixin,
    tagsMixin,
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
      this.$bvModal.show('add-session');
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
    onEditStates(ids) {
      this.editableIds = ids
      this.$bvModal.show('bulk-edit-status')
    },
  },
  mounted() {
    this.$refs['sessions-table'].fetchPaged()
  }
}
</script>
