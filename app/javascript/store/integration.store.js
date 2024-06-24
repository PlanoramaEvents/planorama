import { FETCH } from "./model.store"

export const integrationModel = 'integration'

export const integrationEndpoints = {
  [integrationModel]: 'integration'
}

export const FETCH_AIRMEET_INTEGRATION = 'FETCH AIRMEET INTEGRATION'
export const SET_AIRMEET_INTEGRATION = 'SET AIRMEET INTEGRATION'
export const FETCH_CLYDE_INTEGRATION = 'FETCH CLYDE INTEGRATION'
export const SET_CLYDE_INTEGRATION = 'SET CLYDE INTEGRATION'
export const FETCH_G24RCE_INTEGRATION = 'FETCH G24RCE INTEGRATION'
export const SET_G24RCE_INTEGRATION = 'SET G24RCE INTEGRATION'

export const integrationStore = {
  state: {
    airmeet: {},
    clyde: {},
    g24rce: {}
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
    },
    [SET_G24RCE_INTEGRATION](state, integration) {
      state.g24rce = integration;
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
    },
    [FETCH_G24RCE_INTEGRATION]({ dispatch, commit }) {
      dispatch(FETCH, { url: 'integration/g24rce' }).then(data => {
        commit(SET_G24RCE_INTEGRATION, data)
      })
    }
  }
}
