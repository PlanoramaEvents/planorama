import {http} from "@/http"

export const SET_SETTINGS = "SET SETTINGS";
export const GET_SETTINGS = "GET SETTINGS";
export const SETTINGS_LOADED = "SETTINGS LOADED";

export const settingsStore = {
  state: {
    settings: {},
    settingsLoaded: false
  },
  mutations: {
    [SET_SETTINGS] (state, settings) {
      state.settings = settings
    },
    [SETTINGS_LOADED] (state) {
      state.settingsLoaded = true;
    }
  },
  getters: {
    // Get the current session from the store
    currentSettings(state, getters) {
      return state.settingsLoaded ? state.settings : {};
    }
  },
  actions: {
    [GET_SETTINGS] ({commit, dispatch, state}) {
      // only fetch settings if we don't already have them
      // return a promise with the settings either way
      return new Promise((res, rej) => {
        if(!state.settings.model) {
          http.get("/settings").then((settings) => {
            commit(SET_SETTINGS, settings.data)
            commit(SETTINGS_LOADED)
            res(settings);
          }).catch((error) => {
            // If we can not get the settings, then leave them empty
            commit(SET_SETTINGS, {})
            res({});
          })
        } else {
          res(state.settings);
        }
      })
    },
  }
}
