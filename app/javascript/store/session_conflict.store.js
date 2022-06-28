export const GET_CONFLICTS_FOR_SESSION = 'GET CONFLICTS FOR SESSION';
export const GET_CONFLICTS_WITH_SESSION = 'GET CONFLICTS WITH SESSION';
export const IGNORE_CONFLICT = 'IGNORE CONFLICT'
export const sessionConflictModel = 'session_conflict';

export const sessionConflictEndpoints = {
  [sessionConflictModel]: 'session_conflict'
}

export const sessionConflictStore = {
  actions: {
    [GET_CONFLICTS_WITH_SESSION]  ({commit, dispatch, state}, {session_id}) {
      return new Promise((res, rej) => {
        if(session_id) {
          dispatch('jv/get',`/session_conflict/conflicts_with/${session_id}`).then((conflicts) => {
            res(conflicts);
          })
        } else {
          res({});
        }
      })
    },
    [GET_CONFLICTS_FOR_SESSION] ({commit, dispatch, state}, {session_id}) {
      return new Promise((res, rej) => {
        if(session_id) {
          dispatch('jv/get',`/session_conflict/conflicts_for/${session_id}`).then((conflicts) => {
            res(conflicts);
          })
        } else {
          res({});
        }
      })
    },
    [IGNORE_CONFLICT] ({commit, dispatch, state}, {conflict_id, conflict_type}) {
      console.debug("***** do ignore", conflict_id, conflict_type)
      return new Promise((res, rej) => {
        if(conflict_id && conflict_type) {
          dispatch('jv/get',`/session_conflict/ignore/${conflict_type}/${conflict_id}`)
        } else {
          res({});
        }
      })
    },
  },
  selected: {
    [sessionConflictModel]: undefined
  },
  getters: {
  },
}
