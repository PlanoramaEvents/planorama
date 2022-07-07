<template>
  <div>
    <table-vue
      @new="openNewModal"
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
      <template #cell(visibility)>
        <div class="text-center text-muted">&mdash;</div>
      </template>
    </table-vue>
    <plano-modal id="add-session" title="Add Session" @ok="onNew">
      <b-form-group label="Session Title">
        <b-form-input type="text" v-model="newSessionTitle"></b-form-input>
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

export default {
  name: 'SessionTable',
  components: {
    TableVue,
    TooltipOverflow,
    ModalForm,
    PlanoModal,
  },
  mixins: [
    dateTimeMixin,
    areaMixin
  ],
  data: () => ({
    columns,
    model,
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
    onSave() {
    }
  },
  mounted() {
    this.$refs['sessions-table'].fetchPaged()
  }
}
</script>
