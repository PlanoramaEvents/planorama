export const SET_DRAFT_SCHEDULE = 'SET_DRAFT_SCHEDULE';
export const RESET_DRAFT_SCHEDULE = 'RESET_DRAFT_SCHEDULE';
export const SET_FIRM_SCHEDULE = 'SET_FIRM_SCHEDULE';
export const RESET_FIRM_SCHEDULE = 'RESET_FIRM_SCHEDULE';
import { DateTime } from 'luxon';

export const scheduleStore = {
  state: {
    draftSchedule: false,
    draftScheduledAt: null,
    firmSchedule: false,
    firmScheduledAt: null
  },
  actions: {
    // probably some here for fetching and saving
    // TODO HENRY WIRE ME TO BACKEND
    [SET_DRAFT_SCHEDULE]: ({state}) => {
      state.draftSchedule = true;
      state.draftScheduledAt = DateTime.now().toISO();
      return Promise.resolve({status: 200});
    },
    [RESET_DRAFT_SCHEDULE]: ({state}) => {
      state.draftSchedule = false;
      state.draftScheduledAt = null;
      return Promise.resolve({status: 200});
    },
    [SET_FIRM_SCHEDULE]: ({state}) => {
      state.firmSchedule = true;
      state.firmScheduledAt = DateTime.now().toISO();
      return Promise.resolve({status: 200});
    },
    [RESET_FIRM_SCHEDULE]: ({state}) => {
      state.firmSchedule = false;
      state.firmScheduledAt = null;
      return Promise.resolve({status: 200});
    },
  },
  getters: {
    // need something here to get a person's schedule approval based on the current state
  }

}
