import { personModel } from "@/store/person.store"
import { scheduleWorkflowModel } from "@/store/schedule_workflow";
import { getId } from '@/utils/jsonapi_utils';
import { personScheduleApprovalModel } from "./person_schedule_approval.model";
import { FETCH_APPROVAL_FOR } from './person_schedule_approval.actions';
import { SELECT } from '@/store/model.store';

export const personScheduleApprovalEndpoints = {
  [personScheduleApprovalModel]: 'person_schedule_approval'
}

export const personScheduleApprovalStore = {
  selected: {
    [personScheduleApprovalModel]: undefined
  },
  actions: {
    [FETCH_APPROVAL_FOR] ({dispatch, commit}, {person_id, workflow_id, selected = true}) {
      let url = `/person_schedule_approval/fetch/${person_id}/${workflow_id}`
      let data = { _jv: { type: personScheduleApprovalModel } }

      return new Promise((res, rej) => {
        dispatch('jv/get', [data, {url: url}]).then((approval) => {
          if (selected) {
            commit(SELECT, {personScheduleApprovalModel, itemOrId: approval});
          }
          res(approval);
        }).catch(rej)
      });
    }
  }
}
