import { NEW, FETCH_BY_ID} from './model.store';

export const NEW_MAILING = 'NEW MAILING';
export const GET_MAILING = "GET MAILING";
// export const SAVE_MAILING = "SAVE MAILING";

export const mailingModel = 'mailing';

export const mailingEndpoints = {
  [mailingModel]: 'mailing'
}

export const mailingStore = {
  // ??? state
  actions: {
    [NEW_MAILING] ({dispatch}, attributes) {
      return dispatch(NEW, {model: mailingModel, selected: false, ...attributes})
    },
    // [SAVE_MAILING] ({dispatch}, attributes) {
    //   return dispatch(SAVE, {model: mailingModel, selected: false, ...attributes})
    // },
    // [GET_MAILING] ({commit, dispatch, state}) {
    //
    // },
  },
  selected: {
    [mailingModel]: undefined
  },
  getters: {
  },
}
