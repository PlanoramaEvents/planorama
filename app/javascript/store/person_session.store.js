export const SET_SESSION_USER = "SET SESSION USER";
export const GET_SESSION_USER = "GET SESSION USER";
export const GET_ROLE_BASED_ACCESS_CONTROL = "GET ROLE BASED ACCESS CONTROL";
export const SET_ROLE_BASED_ACCESS_CONTROL = "SET ROLE BASED ACCESS CONTROL";

export const personSessionStore = {
  state: {
    user: {},
    rbac: null,
  },
  mutations: {
    [SET_SESSION_USER] (state, user) {
      state.user = user
    },
    [SET_ROLE_BASED_ACCESS_CONTROL] (state, rbac) {
      state.rbac = rbac
    },
  },
  getters: {
    // Get the current session from the store
    currentPersonSession(state, getters) {
      return state.user;
    },
    currentUserRoles(state, getters) {
      return Object.entries(state.user.person_roles)
      .map(r => r[1].role)
    },
  },
  actions: {
    [GET_SESSION_USER] ({commit, dispatch, state}) {
      // only fetch session if we don't have one
      // return a promise with the session user either way
      return new Promise((res, rej) => {
        if(!state.user.id) {
          // console.debug('******* get the session user')
          dispatch('jv/get','/person/session/me').then((user) => {
            // console.debug('******* session user', user)
            commit(SET_SESSION_USER, user)
            res(user);
          }).catch((error) => {
            // console.debug('******* error', error)
            // If we can not get the session then set no no user
            console.debug("****** WE DO NOT HAVE A VALID SESSION ....")
            commit(SET_SESSION_USER, {})
            res({});
          })
        } else {
          res(state.user);
        }
      })
    },
    // Change so we do not make lots of calls (20) to server for the rbac
    [GET_ROLE_BASED_ACCESS_CONTROL] ({commit, dispatch, state}) {
      // console.debug("GET RBAC....")
      return new Promise((res, rej) => {
        if(!state.rbac) {
          fetch('/rbac').then((response) => {
            // console.debug('******* response', response)
            commit(SET_ROLE_BASED_ACCESS_CONTROL, response);
          }).catch((error) => {
            // console.debug('******* error', error)
            res({});
          })
        } else {
          res(state.rbac);
        }
      })
    }
  }
}
