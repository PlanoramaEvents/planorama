import { FETCH } from '../model.store';
import {
  SET_DRAFT_SCHEDULE,
  RESET_DRAFT_SCHEDULE,
  SET_FIRM_SCHEDULE,
  RESET_FIRM_SCHEDULE,
  FETCH_WORKFLOWS,
} from './schedule_workflow.actions';
import { scheduleWorkflowModel, ScheduleWorkflowState } from './schedule_workflow.model';

export const scheduleWorkflowEndpoints = {
  [scheduleWorkflowModel]: 'schedule_workflow'
}

export const scheduleWorkflowStore = {
  // state: {
  //   draftSchedule: false,
  //   draftScheduledAt: null,
  //   firmSchedule: false,
  //   firmScheduledAt: null
  // },
  actions: {
    // TODO HENRY WIRE ME TO BACKEND
    [SET_DRAFT_SCHEDULE]: ({state}) => {
      // TODO create the draft workflow on the backend
      // note: request for snapshot will happen separately?
      return Promise.resolve({status: 200});
    },
    [RESET_DRAFT_SCHEDULE]: ({state}) => {
      // TODO delete the draft workflow on the backend
      return Promise.resolve({status: 200});
    },
    [SET_FIRM_SCHEDULE]: ({state}) => {
      // TODO create the firm workflow on the backend
      return Promise.resolve({status: 200});
    },
    [RESET_FIRM_SCHEDULE]: ({state}) => {
      // TODO delete the firm workflow from the backend
      return Promise.resolve({status: 200});
    },
    [FETCH_WORKFLOWS]: ({dispatch}) => {
      return dispatch(FETCH, {model: scheduleWorkflowModel});
    }
  },
  getters: {
    draftScheduleWorkflow(_state, getters) {
      // if there's more than one, this will break.
      return Object.values(getters['jv/get'](scheduleWorkflowModel, `$[?(@.state=='${ScheduleWorkflowState.DRAFT}')]`))[0]
    },
    firmScheduleWorkflow(_state, getters) {
      // if there's more than one, this will break.
      return Object.values(getters['jv/get'](scheduleWorkflowModel, `$[?(@.state=='${ScheduleWorkflowState.FIRM}')]`))[0]
    }
  }

}
