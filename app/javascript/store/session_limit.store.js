import {http} from "@/http"

import { NEW } from './model.store';
import {getId} from '@/utils';

export const NEW_SESSION_LIMIT = 'NEW SESSION LIMIT';
export const GET_SESSION_LIMITS = 'GET SESSION LIMITS';
export const FETCH_SESSION_LIMITS_FOR = 'FETCH SESSION LIMITS FOR';

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
    },
    [FETCH_SESSION_LIMITS_FOR] ({dispatch}, personOrId) {
      const personId = getId(personOrId);
      return dispatch('jv/get', `/person/${personId}/${sessionLimitModel}`)
    }
  },
  getters: {
    limitsForPerson(store, getters) {
      return (person) => Object.values(getters['jv/get']({_jv: {type: sessionLimitModel}}, 
        `$[?(@.person_id=='${person.id}')]`
      ))
    },
  }
  // selected: {
  //   [sessionLimitModel]: undefined
  // },
}
