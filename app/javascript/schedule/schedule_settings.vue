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
        <h2>REMOVE ME BEFORE PRODUCTION</h2>
        <b-button variant="primary" @click="reset()">Reset for Testing</b-button>
        <span>THIS DELETES THE SNAPSHOT AND YOU CAN'T EVER GET IT BACK</span>
        <div class="mt-3">Note: this minecart isn't actually hooked up to any status yet. So while it does actually produce a snapshot, the toggle won't
        reflect reality if you reload. There's some TODOs in here. If you try to snapshot and get an error, reset first.
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

export default {
  name: "ScheduleSettings",
  mixins: [
    toastMixin,
    scheduleWorkflowMixin,
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
    SCHEDULE_FIRM_CONFIRM_MESSAGE
  }),
  computed: {
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
      this.toastPromise(http.get('/session/take_snapshot/draft'), "succesfully scheduled snapshot")
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
      this.toastPromise(http.delete('/session/delete_snapshot/draft'), "Draft snapshot deleted")
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
