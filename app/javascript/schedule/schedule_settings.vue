<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12">
        <h5>Release schedule to participants</h5>
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
        <hr />
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <h5>Publish schedule to public</h5>
        <b-table-simple borderless fixed small>
          <b-thead>
            <b-tr>
              <b-td class="text-center">
                <b-button variant="primary" size="sm" :disabled="!canDiff">Show difference</b-button>
              </b-td>
              <b-td colspan="3">
                <b-button variant="primary" size="sm" @click="publishdSchedule()">Create a publish snapshot</b-button>
              </b-td>
            </b-tr>
          </b-thead>
        </b-table-simple>
        <b-table-simple bordered fixed small>
          <b-thead class="text-center">
            <b-tr>
              <b-td class="text-center">Select 2</b-td>
              <b-td colspan="3">Timestamp</b-td>
            </b-tr>
          </b-thead>
          <b-tbody>
            <b-tr v-for="(snap, i) in pubSnapshots" :key="snap.id">
              <b-td class="text-center">
                <b-form-checkbox name="pubs-diff" v-model="pubsDiff[i]" :disabled="pubsDiffCount >= 2 && !pubsDiff[i]"></b-form-checkbox>
              </b-td>
              <b-td colspan="3">{{snap.timestamp}}</b-td>
            </b-tr>
          </b-tbody>
        </b-table-simple>
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

export default {
  name: "ScheduleSettings",
  mixins: [
    toastMixin,
    scheduleWorkflowMixin,
    settingsMixin
  ],
  components: {
    PlanoModal
  },
  data: () => ({
    localDraftSchedule: false,
    draftScheduleConfirmed: false,
    localFirmSchedule: false,
    firmScheduleConfirmed: false,
    SCHEDULE_DRAFT_CONFIRM_MESSAGE,
    SCHEDULE_FIRM_CONFIRM_MESSAGE,
    NODE_ENV,
    mockSnapshots: [
      // {timestamp: '2022-08-01T09:58:00Z', id: '12345'},
      // {timestamp: '2022-08-04T00:24:00Z', id:'67890'}
    ],
    pubsDiff: [false, false, false],
  }),
  computed: {
    pubSnapshots() {
      return [{timestamp: "Current state", id: null}, ...this.mockSnapshots.map(snap => ({...snap, timestamp: DateTime.fromISO(snap.timestamp).toFormat("DDDD, t ZZZZ")}))]
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
    publishdSchedule() {
      this.toastPromise(http.get('/session/schedule_publish'), "Succesfully requested publish")
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
