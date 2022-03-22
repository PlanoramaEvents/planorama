export const SET_SEARCH_STATE = "SET SEARCH STATE";
export const GET_SEARCH_STATE = "GET SEARCH STATE";
export const COMMIT_SEARCH_STATE = "COMMIT SEARCH STATE";

export const searchStateStore = {
  state: {
    currentSearchSettings: {}
  },
  mutations: {
    [COMMIT_SEARCH_STATE] (state, arg) {
      state.currentSearchSettings[arg.key] = arg.setting
    }
  },
  getters: {
    // Get the search state
    // For some reason this is not seen as a getter
    [GET_SEARCH_STATE]: (state) => (key) => {
      console.debug("** GET ", key)
      return state.currentSearchSettings[key]
    }
  },
  actions: {
    // Add search state
    [SET_SEARCH_STATE] ({commit}, {key, setting}) {
      // console.debug("** SET ", key, setting)
      commit(COMMIT_SEARCH_STATE, {key: key, setting: setting})
    }
  }
}
