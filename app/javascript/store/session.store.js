export const SET_SESSION_USER = "SET SESSION USER";
export const GET_SESSION_USER = "GET SESSION USER";

export const sessionStore = {
  state: {
    user: {}
  },
  mutations: {
    [SET_SESSION_USER] (state, user) {
      state.user = user
    },
  },
  getters: {
    // Get the current session from the store
    currentSession(state, getters) {
      return state.user;
    },
  },
  actions: {
    [GET_SESSION_USER] ({commit, dispatch, state}) {
      // only fetch session if we don't have one
      if(!state.user.id) {
        // console.debug('******* get the session user')
        dispatch('jv/get','/session/me').then((user) => {
          // console.debug('******* session user', user)
          commit(SET_SESSION_USER, user)
        }).catch((error) => {
          // console.debug('******* error', error)
          // If we can not get the session then set no no user
          console.debug("****** WE DO NOR HAVE A VALID SESSION ....")
          commit(SET_SESSION_USER, {})
        })
      }
    },
  }
}
