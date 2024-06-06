import { http } from '@/http';
import { FETCH_SELECTED } from './model.store';
import { personModel } from './person.store';

export const personSyncDatumModel = 'person_sync_datum';

export const MATCH = "PERSON SYNC MATCH"

export const personSyncDatumEndpoints = {
  [personSyncDatumModel]: 'person_sync_datum'
}

export const personSyncDatumStore = {
  actions: {
    [MATCH]({dispatch}, {regId, personId, regMatch}) {
      console.log('match action', regId, personId, regMatch)
      return new Promise((res, rej) => {
        http.post(`${personSyncDatumEndpoints[personSyncDatumModel]}/match`, {
          reg_id: regId,
          person_id: personId,
          reg_match: regMatch
      }).then((data) => {
        // if it was successful, also then fetch the person.
        // todo i think we only wnat to do this sometimes?
        dispatch(FETCH_SELECTED, {model: personModel}).then(() => {
          res(data);
        })

      }).catch(rej);
    });
    }
  },
  selected: {
    [personSyncDatumModel]: undefined
  },
  getters: {
  }
}
