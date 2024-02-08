import { FETCH } from "./model.store"

export const integrationModel = 'integration'

export const integrationEndpoints = {
  [integrationModel]: 'integration'
}

export const FETCH_AIRMEET_INTEGRATION = 'FETCH AIRMEET INTEGRATION'
export const SET_AIRMEET_INTEGRATION = 'SET AIRMEET INTEGRATION'
export const FETCH_CLYDE_INTEGRATION = 'FETCH CLYDE INTEGRATION'
export const SET_CLYDE_INTEGRATION = 'SET CLYDE INTEGRATION'

export const integrationStore = {
  state: {
    airmeet: {},
    clyde: {}
  },
  getters: {
    airmeetEnabled(state) {
      return state.airmeet?.config?.enabled;
    },
  },
  mutations: {
    [SET_AIRMEET_INTEGRATION] (state, integration) {
      state.airmeet = integration;
    },
    [SET_CLYDE_INTEGRATION] (state, integration) {
      state.clyde = integration;
    }
  },
  actions: {
    [FETCH_AIRMEET_INTEGRATION] ({dispatch, commit}) {
      dispatch(FETCH, {url: 'integration/airmeet'}).then(data => {
        commit(SET_AIRMEET_INTEGRATION, data);
      })
    },
    [FETCH_CLYDE_INTEGRATION] ({dispatch, commit}) {
      dispatch(FETCH, {url: 'integration/clyde'}).then(data => {
        commit(SET_CLYDE_INTEGRATION, data)
      })
    }
  }
}
