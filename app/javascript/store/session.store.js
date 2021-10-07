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
  actions: {
    [GET_SESSION_USER] ({commit, dispatch, state}) {
      // only fetch session if we don't have one
      if(!state.user.id) {
        // console.debug('******* get the session user')
        dispatch('jv/get','/people/me').then((user) => {
          // console.debug('******* session user', user)
          commit(SET_SESSION_USER, user)
        }).catch((error) => {
          // console.debug('******* error', error)
          // If we can not get the session then set no no user
          commit(SET_SESSION_USER, {})
        })
      }
    },
  }
}
