import { modelMixinNoProp } from "@/store/model.mixin";
import { modelUtilsMixin } from "@/store/model_utils.mixin";

import { mapActions } from "vuex";

import { personScheduleApprovalModel as model} from "./person_schedule_approval.model";
import { personModel } from "@/store/person.store";

import { scheduleWorkflowMixin, ScheduleWorkflowState } from '@/store/schedule_workflow';
import { FETCH_APPROVAL_FOR } from "./person_schedule_approval.actions";

export const personScheduleApprovalMixin = {
  mixins: [
    modelMixinNoProp,
    scheduleWorkflowMixin,
    modelUtilsMixin
  ],
  data: () => ({
    model,
    keepSelectedUpToDate: null
  }),
  methods: {
    ...mapActions({
      fetchApprovalFor: FETCH_APPROVAL_FOR
    }),
    fetchSelectedPersonApprovalForState(workflowState) {
      // for this instance, on workflowState change, reload this
      this.keepSelectedUpToDate = workflowState;
      let workflow;
      switch(workflowState) {
        case ScheduleWorkflowState.FIRM:
          workflow = this.firmScheduleWorkflow
          break;
        case ScheduleWorkflowState.DRAFT:
          workflow = this.draftScheduleWorkflow
          break;
        default:
          // not set or something bad
          break;
      }

      if (!workflow) {
        // abort fetch
        return Promise.reject({status: 422, errors: [{title: 'Validation error: no workflow state provided'}]});
      }

      const person = this.selected_model(personModel)
      if (!person) {
        // no point in continuing
        return Promise.reject({status: 422, errors: [{title: 'Validation error: no person selected'}]});
      }

      // this will also select it for us :) how handy
      return this.fetchApprovalFor({person_id: person.id, workflow_id: workflow.id})
    },
  },
  watch: {
    firmScheduleWorkflow (newVal, oldVal) {
      if (newVal && newVal !== oldVal && this.keepSelectedUpToDate === ScheduleWorkflowState.FIRM) {
        this.fetchSelectedPersonApprovalForState(this.keepSelectedUpToDate);
      }
    },
    draftScheduleWorkflow (newVal, oldVal) {
      if (newVal && newVal !== oldVal && this.keepSelectedUpToDate === ScheduleWorkflowState.DRAFT) {
        this.fetchSelectedPersonApprovalForState(this.keepSelectedUpToDate);
      }
    },
  }

}

export default personScheduleApprovalMixin;
