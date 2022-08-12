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
        <div v-if="currentSettings.env !== 'production'">
          <b-button variant="primary" @click="reset()">Reset for Testing</b-button>
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
              <b-td class="text-center">
                <b-button variant="primary" size="sm" :disabled="!canDiff" @click="diff">Show difference</b-button>
              </b-td>
              <b-td colspan="3" class="text-right">
                <icon-button icon="arrow-repeat" class="mr-2" @click="fetchPublicationDates()"></icon-button>
                <b-button variant="primary" size="sm" v-b-modal.confirm-publish>Create a publish snapshot</b-button>
              </b-td>
            </b-tr>
          </b-thead>
        </b-table-simple>
        <b-table
          :fields="[{key: 'select_2', tdClass: 'text-center', thClass: 'text-center' }, {key: 'timestamp', tdClass: 'text-right', thClass: 'text-right', thAttr: {'colspan': 2}, tdAttr: {'colspan': 2}}]" 
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
        </b-table>
        <div v-if="currentSettings.env !== 'production'">
          <b-button variant="primary" @click="resetPubs()">Reset Publish for Testing</b-button>
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

export default {
  name: "ScheduleSettings",
  mixins: [
    toastMixin,
    scheduleWorkflowMixin,
    settingsMixin
  ],
  components: {
    PlanoModal,
    IconButton
  },
  data: () => ({
    localDraftSchedule: false,
    draftScheduleConfirmed: false,
    localFirmSchedule: false,
    firmScheduleConfirmed: false,
    SCHEDULE_DRAFT_CONFIRM_MESSAGE,
    SCHEDULE_FIRM_CONFIRM_MESSAGE,
    NODE_ENV,
    snapshots: [ ],
    pubsDiff: [],
    pubsLoading: false,
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
    }
  },
  methods: {
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
      this.$store.dispatch('jv/get', '/publication_date').then((data) => {
        const {_jv, ...filteredData} = data;
        this.snapshots = Object.values(filteredData).map(s => ({timestamp: s.timestamp, id: s.id}))
        this.snapshots.sort((a, b) => DateTime.fromISO(b.timestamp) - DateTime.fromISO(a.timestamp));
        this.pubsDiff = [false, ...Object.keys(filteredData).map(s => false)];
        this.pubsLoading = false;
      })
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
