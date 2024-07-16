import { http } from "@/http";
import { FETCH, SELECT, UNSELECT } from "./model.store";

export const registrationSyncDatumModel = 'registration_sync_datum';
const model = registrationSyncDatumModel;
export const registrationSyncStatisticsModel = 'registration_sync_statistics'

export const GET_REG_BY_ID = "GET REG BY ID";
export const REG_SYNC_STATS = "REG SYNC STATS";
export const SET_REG_SYNC_STATS = "SET REG SYNC STATS";
export const FETCH_REG_SYNC_STATS = "FETCH REG SYNC STATS";

export const registrationSyncDatumEndpoints = {
  [registrationSyncDatumModel]: 'registration_sync_datum',
  [registrationSyncStatisticsModel]: 'registration_sync_data/sync_statistics'
}

export const registrationSyncDatumStore = {
  selected: {
    [registrationSyncDatumModel]: undefined
  },
  state: {
    registrationSyncStats: {}
  },
  getters: {
    [REG_SYNC_STATS](state) {
      return state.registrationSyncStats;
    }
  },
  mutations: {
    [SET_REG_SYNC_STATS](state, syncStats) {
      state.registrationSyncStats = syncStats;
    }
  },
  actions: {
    [GET_REG_BY_ID]({ commit, dispatch }, { id }) {
      return new Promise((res, rej) => {
        dispatch(FETCH, {
          model, params: {
            // trying without the %23 here in the hope that fetch will serialize correctly
            filter: `{"op":"all","queries":[["registration_number","is","${id}"]]}`
          }
        }).then((data) => {
          const keys = Object.keys(data).filter(key => key !== "_jv")
          if (keys.length) {
            commit(SELECT, { model, itemOrId: keys[0] })
          } else {
            commit(UNSELECT, { model });
          }
          res(data);
        }).catch(rej);
      })
    },
    [FETCH_REG_SYNC_STATS]({ commit }) {
      return http.get(registrationSyncDatumEndpoints[registrationSyncStatisticsModel]).then(({ data }) =>
        commit(SET_REG_SYNC_STATS, data))
    }
  },
}
