export const GET_CONFLICTS_FOR_SESSION = 'GET CONFLICTS FOR SESSION';
export const sessionConflictModel = 'session_conflict';

export const sessionConflictEndpoints = {
  [sessionConflictModel]: 'session_conflict'
}

export const sessionConflictStore = {
  actions: {
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
    }
  },
  selected: {
    [sessionConflictModel]: undefined
  },
  getters: {
  },
}
