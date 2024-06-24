<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12">
        <b-form-group label-cols="auto" class="align-items-center">
          <template #label>Release <strong>Draft</strong> Schedule to Participants</template>
          <b-form-checkbox switch v-model="localDraftSchedule" :disabled="localDraftSchedule" @change="openDraftConfirm" id="draft-schedule-checkbox" aria-describedby="draft-schedule-date"></b-form-checkbox>
          <span class="small text-muted" id="draft-schedule-date" v-if="localDraftSchedule">{{draftScheduledAtText}}</span>
        </b-form-group>
        <b-form-group label-cols="auto" class="align-items-center" label="Release Firm Schedule to Participants">
          <b-form-checkbox id="firm-schedule-checkbox" switch v-model="localFirmSchedule" @change="openFirmConfirm" :disabled="!localDraftSchedule || localFirmSchedule" inline aria-describedby="firm-schedule-date"></b-form-checkbox>
          <span class="small text-muted" id="firm-schedule-date" v-if="localFirmSchedule">{{firmScheduledAtText}}</span>
        </b-form-group>
        <single-config-manager parameterName="show_join_links">
          <template #default="{onChange, config}">
            <b-form-group label-cols="auto" class="align-items-center" label="Show join links to participants">
              <b-form-checkbox 
                id="show-join-links-checkbox" 
                switch 
                v-model="config.parameter_value" 
                @change="onChange" 
                :disabled="!localFirmSchedule" 
                inline
                aria-describedby="show-join-links-date show-join-links-caveat"
                value="true"
                unchecked-value="false"
              ></b-form-checkbox>
              <span class="small text-muted" id="show-join-links-date" v-if="config.parameter_value === 'true'">{{ formatTime(config.updated_at) }}</span>
              <div class="d-block ml-2 small text-muted font-italic" id="show-join-links-caveat">In order for this to take effect, you <strong style="font-size: 100%">must</strong> reload Planorama.</div>
            </b-form-group>
          </template>
        </single-config-manager>
        <div v-if="currentSettings.env !== 'production'">
          <b-button variant="danger" @click="reset()">Reset for Testing</b-button>
          <span>THIS DELETES THE SNAPSHOT AND YOU CAN'T EVER GET IT BACK</span>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <h5>Publish schedule to public</h5>
        <b-table-simple borderless fixed small style="width: 35rem;">
          <b-thead>
            <b-tr>
              <b-td colspan="3" class="text-center">
                <b-button variant="primary" size="sm" :disabled="!canDiff" @click="diff">Show difference</b-button>
              </b-td>
              <b-td colspan="13" class="text-right">
                <icon-button icon="arrow-repeat" class="mr-2" @click="fetchPublicationDates()"></icon-button>
                <b-button variant="primary" size="sm" v-b-modal.confirm-publish>Create a publish snapshot</b-button>
              </b-td>
            </b-tr>
          </b-thead>
        </b-table-simple>
        <b-table
          :fields="[{key: 'select_2', tdClass: 'text-center', thClass: 'text-center',  thAttr: {'colspan': 3}, tdAttr: {'colspan': 3} }, {key: 'timestamp', tdClass: 'text-right', thClass: 'text-right', thAttr: {'colspan': 10}, tdAttr: {'colspan': 10}}, {key: 'sent_external', tdClass: 'text-center', thClass: 'text-center', thAttr: {'colspan': 3}, tdAttr: {'colspan': 3}, label: 'External'}]" 
          bordered
          fixed
          small
          sticky-header
          :items="pubSnapshots"
          style="width: 35rem;"
          :busy="pubsLoading"
        >
          <template #table-busy>
            <div class="d-flex justify-content-center">
              <b-spinner variant="primary"></b-spinner>
            </div>
          </template>
          <template #cell(select_2)="{ index }">
            <b-form-checkbox name="pubs-diff" v-model="pubsDiff[index]" :disabled="pubsDiffCount >= 2 && !pubsDiff[index]"></b-form-checkbox>
          </template>
          <template #cell(timestamp)="{ item, index }">
            <div v-if="!index">{{item.timestamp}}</div>
            <div v-b-tooltip.html.right="`New Sessions: ${item.new_sessions}<br />Dropped Sessions: ${item.dropped_sessions}<br />Updated Sessions: ${item.updated_sessions}<br />New Assignments: ${item.new_assignments}<br />Dropped Assignments: ${item.dropped_assignments}<br />Updated Assignments: ${item.updated_assignments}`" v-if="index">{{item.timestamp}}</div>
          </template>
          <template #cell(sent_external)="{ index, item }">
            <b-form-checkbox switch v-if="index" :checked="item.sent_external" @change="patchSentExternal(item, $event)"></b-form-checkbox>
          </template>
        </b-table>
        <div v-if="currentSettings.env !== 'production'">
          <b-button variant="danger" @click="resetPubs()">Reset Publish for Testing</b-button>
          <span>THIS DELETES ALL THE PUBLISHED DATA AND YOU CAN'T EVER GET IT BACK</span>
        </div>
      </div>
    </div>
    <plano-modal id="confirm-draft-modal" @cancel="cancelDraft()" @close="cancelDraft()" no-close-on-backdrop @ok="confirmDraft()">
      <template #modal-title>Publish Draft Schedule Confirmation</template>
      {{SCHEDULE_DRAFT_CONFIRM_MESSAGE}}
    </plano-modal>
    <plano-modal id="confirm-firm-modal" @cancel="cancelFirm()" @close="cancelFirm()" no-close-on-backdrop @ok="confirmFirm()">
      <template #modal-title>Publish Firm Schedule Confirmation</template>
      {{SCHEDULE_FIRM_CONFIRM_MESSAGE}}
    </plano-modal>
    <plano-modal id="confirm-publish" @ok="publishdSchedule()">
      <template #modal-title>Publish Schedule To Public Confirmation</template>
      This will publish the schedule and make the current version of it available to external sources. This action is
      irreversible and will bring the server down for a short time. Please double check that you wish to perform this action.
    </plano-modal>
  </div>
</template>

<script>
import PlanoModal from '@/components/plano_modal.vue';
import { toastMixin } from '@/mixins';
import { http } from '@/http';
import {
  SCHEDULE_DRAFT_CONFIRM_MESSAGE,
  SCHEDULE_FIRM_CONFIRM_MESSAGE,
} from '@/constants/strings';

import { scheduleWorkflowMixin } from '@/store/schedule_workflow';
import settingsMixin from "@/store/settings.mixin";
import { DateTime } from 'luxon';
import IconButton from '@/components/icon_button.vue';
import { modelMixinNoProp } from '@/store/model.mixin';
import { publicationDatesModel as model } from '@/store/publication_dates.store'
import SingleConfigManager from '@/configurations/single_config_manager.vue';

export default {
  name: "ScheduleSettings",
  mixins: [
    toastMixin,
    scheduleWorkflowMixin,
    settingsMixin,
    modelMixinNoProp
  ],
  components: {
    PlanoModal,
    IconButton,
    SingleConfigManager,
  },
  data: () => ({
    localDraftSchedule: false,
    draftScheduleConfirmed: false,
    localFirmSchedule: false,
    firmScheduleConfirmed: false,
    SCHEDULE_DRAFT_CONFIRM_MESSAGE,
    SCHEDULE_FIRM_CONFIRM_MESSAGE,
    NODE_ENV,
    pubsDiff: [],
    pubsLoading: false,
    model
  }),
  computed: {
    pubSnapshots() {
      return [{timestamp: "Current state", id: null}, ...this.snapshots.map(snap => ({...snap, timestamp: DateTime.fromISO(snap.timestamp).toFormat("DDDD, t ZZZZ")}))]
    },
    pubsDiffCount() {
      return this.pubsDiff.filter(pd => pd).length
    },
    canDiff() {
      return this.pubsDiffCount === 2;
    },
    draftScheduledAtText() {
      return this.draftScheduleConfirmed ? this.draftScheduledAt : "Pending";
    },
    firmScheduledAtText() {
      return this.firmScheduleConfirmed ? this.firmScheduledAt : "Pending";
    },
    snapshots() {
      const snaps = this.collection;
      snaps.sort((a, b) => DateTime.fromISO(b.timestamp) - DateTime.fromISO(a.timestamp));
      return snaps;
    }
  },
  methods: {
    formatTime(val) {
      return DateTime.fromISO(val).toFormat('D, t ZZZZ');
    },
    openDraftConfirm(val) {
      if (val) {
        this.$bvModal.show("confirm-draft-modal")
      }
    },
    openFirmConfirm(val) {
      if (val) {
        this.$bvModal.show("confirm-firm-modal")
      }
    },
    cancelDraft() {
      this.localDraftSchedule = false;
    },
    cancelFirm() {
      this.localFirmSchedule = false;
    },
    confirmDraft() {
      this.draftScheduleConfirmed = true;
      this.draftSchedule = true;
    },
    confirmFirm() {
      this.firmScheduleConfirmed = true;
      this.firmSchedule = true;
    },
    reset() {
      this.localDraftSchedule = false;
      this.localFirmSchedule = false;
      this.draftSchedule = false;
      this.firmSchedule = false;
      this.toastPromise(http.get('/schedule_workflow/reset'), "succesfully reset workflows")
    },
    resetPubs() {
      this.toastPromise(http.get('/publication_date/reset'), "succesfully reset publication data")
    },
    //
    publishdSchedule() {
      this.toastPromise(http.get('/session/schedule_publish'), "Succesfully requested publish")
    },
    diff() {
      console.log('clicked diff');
      const ids = this.snapshots.filter((s, i) => this.pubsDiff[i+1]).map(s => s.id)
      // these will be in reverse time order because magic!
      let url = '/report/schedule_reports/schedule_diff'
      if(ids.length > 1) {
        url += `/${ids[1]}/${ids[0]}`
      } else {
        url += `/${ids[0]}`
      }
      console.log('going to url', url)
      window.open(url, '_blank');
    },
    fetchPublicationDates() {
      this.pubsLoading = true;
      this.fetch().then((_) => {
        this.pubsDiff = [false, ...this.collection.map(s => false)];
        this.pubsLoading = false;
      })
    },
    patchSentExternal(item, sent_external) {
      this.patch(item, {sent_external}, false, "Successfully updated the publication metadata.", "Failed to update the publication metadata")
    }
  },
  watch: {
    draftSchedule(newVal, oldVal) {
      if (newVal != oldVal) {
        this.localDraftSchedule = newVal;
        this.draftScheduleConfirmed = newVal;
      }
    },
    firmSchedule(newVal, oldVal) {
      if (newVal != oldVal) {
        this.localFirmSchedule = newVal;
        this.firmScheduleConfirmed = newVal;
      }
    }
  },
  mounted() {
    this.fetchScheduleWorkflows().then(() => {
      // TODO: this does not look right, what is done with the workflow return data?
      this.localDraftSchedule = this.draftSchedule;
      this.draftScheduleConfirmed = this.draftSchedule;
      this.localFirmSchedule = this.firmSchedule;
      this.firmScheduleConfirmed = this.firmSchedule;
    })
    this.fetchPublicationDates();
  }
}
</script>

<style>
#schedule-settings-accordion .form-group.align-items-center .form-row .col {
  align-self: center;
  display: flex;
  align-items: center;
}


</style>
