<template>
  <div class="container-fluid">
    <div class="row">
      <div class="col-12">
        <b-form-group label-cols="auto" class="align-items-center">
          <template #label>Release <strong>Draft</strong> Schedule to Participants</template>
          <b-form-checkbox switch v-model="draftSchedule" :disabled="draftSchedule" @change="openDraftConfirm" id="draft-schedule-checkbox" aria-describedby="draft-schedule-date"></b-form-checkbox>
          <span class="small text-muted" id="draft-schedule-date" v-if="draftSchedule">{{draftScheduledAt}}</span>
        </b-form-group>
        <b-form-group label-cols="auto" class="align-items-center" label="Release Firm Schedule to Participants">
          <b-form-checkbox id="firm-schedule-checkbox" switch v-model="firmSchedule" @change="openFirmConfirm" :disabled="!draftSchedule || firmSchedule" inline aria-describedby="firm-schedule-date"></b-form-checkbox>
          <span class="small text-muted" id="firm-schedule-date" v-if="firmSchedule">{{firmScheduledAt}}</span>
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
      <template #modal-title>Confirm Draft Publish</template>
      {{SCHEDULE_DRAFT_CONFIRM_MESSAGE}}
    </plano-modal>
    <plano-modal id="confirm-firm-modal" @cancel="cancelFirm()" @close="cancelFirm()" no-close-on-backdrop @ok="confirmFirm()">
      <template #modal-title>Confirm Firm Publish</template>
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
  SCHEDULE_DRAFT_SUCCESS_MESSAGE,
  SCHEDULE_FIRM_SUCCESS_MESSAGE
} from '@/constants/strings';

export default {
  name: "ScheduleSettings",
  mixins: [
    toastMixin
  ],
  components: {
    PlanoModal
  },
  data: () => ({
    draftSchedule: false,
    draftScheduleConfirmed: false,
    firmSchedule: false,
    firmScheduleConfirmed: false,
    SCHEDULE_DRAFT_CONFIRM_MESSAGE,
    SCHEDULE_FIRM_CONFIRM_MESSAGE
  }),
  computed: {
    draftScheduledAt() {
      return this.draftScheduleConfirmed ? "Whatever date this happened at will be here." : "Pending";
    },
    firmScheduledAt() {
      return this.firmScheduleConfirmed ? "Whatever date this happened at will be here." : "Pending";
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
      this.draftSchedule = false;
    },
    cancelFirm() {
      this.firmSchedule = false;
    },
    confirmDraft() {
      this.draftScheduleConfirmed = true;
      this.toastPromise(http.get('/session/take_snapshot/draft'), SCHEDULE_DRAFT_SUCCESS_MESSAGE)
    },
    confirmFirm() {
      this.firmScheduleConfirmed = true;
      alert("this doesn't do anything yet");
    },
    reset() {
      this.draftSchedule = false;
      this.firmSchedule = false;
      this.toastPromise(http.delete('/session/delete_snapshot/draft'), "Draft snapshot deleted")
    }
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
