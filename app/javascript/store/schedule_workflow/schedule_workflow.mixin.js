import { mapGetters, mapActions } from 'vuex';
import { FETCH_WORKFLOWS, RESET_DRAFT_SCHEDULE, RESET_FIRM_SCHEDULE, SET_DRAFT_SCHEDULE, SET_FIRM_SCHEDULE } from './schedule_workflow.actions';
import { DateTime } from 'luxon';
import { toastMixin } from '@/mixins';
import { SCHEDULE_DRAFT_SUCCESS_MESSAGE, SCHEDULE_FIRM_SUCCESS_MESSAGE } from '@/constants/strings';

export const scheduleWorkflowMixin = {
  mixins: [
    toastMixin
  ],
  computed: {
    ...mapGetters(['draftScheduleWorkflow', 'firmScheduleWorkflow']),
    liveScheduleTitle() {
      return this.firmSchedule ? 'Firm Schedule' : 'Live Schedule';
    },
    draftSchedule: {
      get() {
        return !!this.draftScheduleWorkflow
      },
      set(val) {
        if (val) {
          this.setDraftSchedule();
        } else {
          // do nothing! reset handled elsewhere
        }
      }
    },
    firmSchedule: {
      get() {
        return !!this.firmScheduleWorkflow
      },
      set(val) {
        if (val) {
          this.setFirmSchedule();
        } else {
          // do nothing! reset handled elsewhere
        }
      }
    },
    displayDraftSchedule() {
      // should be true when draftSchedule is true and firmSchedule is false
      return this.draftSchedule && !this.firmSchedule;
    },
    draftScheduledAt() {
      return DateTime.fromISO(this.draftScheduleWorkflow?.set_at).toLocaleString();
    },
    firmScheduledAt() {
      return DateTime.fromISO(this.firmScheduleWorkflow?.set_at).toLocaleString();
    }
  },
  methods: {
    ...mapActions({
      setDraftScheduleAction: SET_DRAFT_SCHEDULE,
      setFirmScheduleAction: SET_FIRM_SCHEDULE,
      fetchScheduleWorkflows: FETCH_WORKFLOWS
    }),
    setDraftSchedule() {
      this.toastPromise(this.setDraftScheduleAction(), SCHEDULE_DRAFT_SUCCESS_MESSAGE);
    },
    setFirmSchedule() {
      this.toastPromise(this.setFirmScheduleAction(), SCHEDULE_FIRM_SUCCESS_MESSAGE);
    },
  }
}

export default scheduleWorkflowMixin;
