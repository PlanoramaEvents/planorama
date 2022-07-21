import { FETCH, NEW } from '../model.store';
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
  actions: {
    [SET_DRAFT_SCHEDULE]: ({dispatch}) => {
      let workflow = {
        state: 'draft'
      }
      return dispatch(NEW, {model: scheduleWorkflowModel, selected: false, ...workflow});
    },
    [SET_FIRM_SCHEDULE]: ({dispatch}) => {
      let workflow = {
        state: 'firm'
      }
      return dispatch(NEW, {model: scheduleWorkflowModel, selected: false, ...workflow});
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
