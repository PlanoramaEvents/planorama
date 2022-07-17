import { FETCH_BY_RELATIONSHIPS } from "@/store/model.store"
import { personModel } from "@/store/person.store"
import { scheduleWorkflowModel } from "@/store/schedule_workflow";
import { getId } from '@/utils/jsonapi_utils';
import { personScheduleApprovalModel } from "./person_schedule_approval.model";
import { FETCH_APPROVAL_FOR } from './person_schedule_approval.actions';


export const personScheduleApprovalEndpoints = {
  [personScheduleApprovalModel]: 'person_schedule_approval'
}

export const personScheduleApprovalStore = {
  selected: {
    [personScheduleApprovalModel]: undefined
  },
  actions: {
    [FETCH_APPROVAL_FOR] ({dispatch}, {personOrId, workflowOrId, selected = true}) {
      const relationships = {
        [personModel]: {
          data: {
            type: personModel,
            id: getId(personOrId)
          }
        },
        [scheduleWorkflowModel]: {
          data: {
            type: scheduleWorkflowModel,
            id: getId(workflowOrId)
          }
        }
      }
      return dispatch(FETCH_BY_RELATIONSHIPS, {model: personScheduleApprovalModel, relationships, selected})
    }
  }
}
