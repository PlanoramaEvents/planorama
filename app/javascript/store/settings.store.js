import {http} from "@/http"

export const SET_SETTINGS = "SET SETTINGS";
export const GET_SETTINGS = "GET SETTINGS";

export const settingsStore = {
  state: {
    settings: {}
  },
  mutations: {
    [SET_SETTINGS] (state, settings) {
      state.settings = settings
    },
  },
  getters: {
    // Get the current session from the store
    currentSettings(state, getters) {
      return state.settings;
    },
  },
  actions: {
    [GET_SETTINGS] ({commit, dispatch, state}) {
      // only fetch settings if we don't already have them
      // return a promise with the settings either way
      return new Promise((res, rej) => {
        if(!state.settings.model) {
          // console.debug('******* get the settings')
          http.get("/settings").then((settings) => {
           console.debug('******* settings', settings)
           commit(SET_SETTINGS, settings.data)
            res(settings);
          }).catch((error) => {
            // console.debug('******* error', error)
            // If we can not get the settings, then leave them empty
            console.debug("****** WE DO NOT HAVE ANY SETTINGS! ....")
            // commit(SET_SETTINGS, {})
            res({});
          })
        } else {
          res(state.settings);
        }
      })
    },
  }
}
