import { http } from '@/http';
import { FETCH_SELECTED } from './model.store';
import { personModel } from './person.store';

export const personSyncDatumModel = 'person_sync_datum';

export const MATCH = "PERSON SYNC MATCH"
export const DISMISS = "PERSON SYNC DISMISS"
export const FETCH_MATCH_COUNT = "PERSON SYNC POTENTIAL MATCHES COUNT"
export const SET_MATCH_COUNT = "PERSON SYNC POTENTIAL MATCHES COUNT"

export const personSyncDatumEndpoints = {
  [personSyncDatumModel]: 'person_sync_datum'
}

export const personSyncDatumPageSize = {
  [personSyncDatumModel]: 2000
}

export const personSyncDatumStore = {
  actions: {
    [MATCH]({dispatch}, {regId, personId, regMatch, reload = false}) {
      console.log('match action', regId, personId, regMatch)
      return new Promise((res, rej) => {
        http.post(`${personSyncDatumEndpoints[personSyncDatumModel]}/match`, {
          reg_id: regId,
          person_id: personId,
          reg_match: regMatch
      }).then((data) => {
        // if it was successful, also then fetch the person.
        // todo i think we only wnat to do this sometimes?
        if (reload) {
          dispatch(FETCH_SELECTED, {model: personModel}).then(() => {
            res(data);
          })
        } else {
          res(data);
        }

      }).catch(rej);
    });
    },
    [FETCH_MATCH_COUNT] ({commit}) {
      return new Promise((res, rej) => {
        http.get(`${personSyncDatumEndpoints[personSyncDatumModel]}/possible_match_count`).then(data => {
          commit(SET_MATCH_COUNT, data.data.total);
          console.log('match count data:', data)
          res(data);
        }).catch(rej);
      })
    },
    [DISMISS] ({}, {regId, personId}) {
      return new Promise((res, rej) => {
        http.post(`${personSyncDatumEndpoints[personSyncDatumModel]}/dismiss_match`, {
        reg_id: regId,
        person_id: personId
      }).then((data) => {
        console.log(data);  
        res(data);
      }).catch(rej)
      });
    }
  },
  selected: {
    [personSyncDatumModel]: undefined
  },
  page: {
    [personSyncDatumModel]: {
      usePaged: true,
      total: undefined,
      fullTotal: undefined,
      currentPage: undefined,
      perPage: undefined,
      correctOrder: [],
    }
  },
  state: {
    possibleMatchCount: undefined,
  },
  getters: {
  },
  mutations: {
    [SET_MATCH_COUNT] (state, count) {
      state.possibleMatchCount = count;
    }
  }
}
