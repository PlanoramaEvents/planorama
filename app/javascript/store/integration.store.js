import { FETCH } from "./model.store"

export const integrationModel = 'integration'

export const integrationEndpoints = {
  [integrationModel]: 'integration'
}

export const FETCH_AIRMEET_INTEGRATION = 'FETCH AIRMEET INTEGRATION'
export const SET_AIRMEET_INTEGRATION = 'SET AIRMEET INTEGRATION'
export const FETCH_REGISTRATION_INTEGRATION = 'FETCH REGISTRATION INTEGRATION'
export const SET_REGISTRATION_INTEGRATION = 'SET REGISTRATION INTEGRATION'
export const FETCH_G24RCE_INTEGRATION = 'FETCH G24RCE INTEGRATION'
export const SET_G24RCE_INTEGRATION = 'SET G24RCE INTEGRATION'

export const integrationStore = {
  state: {
    airmeet: {},
    registration: {},
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
    [SET_REGISTRATION_INTEGRATION] (state, integration) {
      state.registration = integration;
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
    [FETCH_REGISTRATION_INTEGRATION] ({dispatch, commit}) {
      dispatch(FETCH, {url: 'integration/registration'}).then(data => {
        commit(SET_REGISTRATION_INTEGRATION, data)
      })
    },
    [FETCH_G24RCE_INTEGRATION]({ dispatch, commit }) {
      dispatch(FETCH, { url: 'integration/g24rce' }).then(data => {
        commit(SET_G24RCE_INTEGRATION, data)
      })
    }
  }
}
