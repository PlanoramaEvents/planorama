import {http} from "@/http"

import { NEW } from './model.store';

export const NEW_SESSION_LIMIT = 'NEW SESSION LIMIT';
export const GET_SESSION_LIMITS = 'GET SESSION LIMITS';

export const sessionLimitModel = 'session_limit';

export const sessionLimitEndpoints = {
  [sessionLimitModel]: 'session_limit'
}

export const sessionLimitStore = {
  actions: {
    [NEW_SESSION_LIMIT] ({dispatch}, {limit}) {
      return dispatch(NEW, {model: sessionLimitModel, selected: false, ...limit});
    },
    [GET_SESSION_LIMITS] ({commit, dispatch, state}) {
      return new Promise((res, rej) => {
        if(state.user.id) {
          dispatch('jv/get',`/person/${state.user.id}/session_limit`).then((limits) => {
            res(limits);
          })
        } else {
          res({});
        }
      })
    }
  },
  // selected: {
  //   [sessionLimitModel]: undefined
  // },
  // getters: {
  // },
}
