import { NEW, PATCH_FIELDS, SELECT } from './model.store';
import { GET_SESSION_USER } from './person_session.store';

export const NEW_PERSON = 'NEW PERSON';
export const PATCH_PERSON_MODEL = 'PATCH_PERSON_MODEL';
export const UNLINK_PERSON = 'UNLINK PERSON';
export const RESYNC_PERSON = 'RESYNC PERSON';
export const GET_PERSON_SURVEYS = 'GET PERSON SURVEYS';

export const personModel = 'person';

export const personEndpoints = {
  [personModel]: 'person'
}

export const personStore = {
  actions: {
    [NEW_PERSON] ({dispatch}, attributes) {
      return dispatch(NEW, {model: personModel, selected: false, ...attributes})
    },
    [PATCH_PERSON_MODEL] ({dispatch}, {person, data}) {
      const item = {
        id: person.id,
        lock_version: person.lock_version,
        ...data
      }
      return dispatch(PATCH_FIELDS, {model: personModel, item, fields: Object.keys(data), selected: false })
    },
    [UNLINK_PERSON] ({dispatch, commit}, {person, select = true}) {
      const model = personModel;
      // limited field selection
      let smallItem = {
        // always include lock version so that we have optimistic locking
        lock_version: person.lock_version || 0,
        id: person.id,
        _jv: {
          type: model,
          id: person.id
        }
      }
      return new Promise((res, rej) => {
        dispatch('jv/post', [smallItem, {url: `/person/${person.id}/unlink_registration`}]).then((savedModel) => {
          if(select) {
            commit(SELECT, {model, itemOrId: savedModel});
          }
          dispatch(GET_SESSION_USER, {force: true}).then(() => {
            res(savedModel);
          });
        }).catch(rej);
      });
    },
    [RESYNC_PERSON]({ dispatch, commit }, { person }) {
      const model = personModel;
      // limited field selection
      let smallItem = {
        // always include lock version so that we have optimistic locking
        lock_version: person.lock_version,
        id: person.id,
        _jv: {
          type: model,
          id: person.id
        }
      }
      return new Promise((res, rej) => {
        dispatch('jv/post', [smallItem, { url: `/person/${person.id}/clyde_sync` }]).then((savedModel) => {
          // person should always be selected at this point so we shouldn't check, we should just select.
          commit(SELECT, { model, itemOrId: savedModel });
          res(savedModel);
          // This is done by admin to selected user so this is not the session user
        }).catch(rej);
      });
    },
    [GET_PERSON_SURVEYS] ({dispatch, commit}, {person}) {
      return new Promise((res, rej) => {
        // todo actually get the data here
        // or does this work?
        // answer - no, it doesn't. we don't know why
        // TODO figure out why getRelated doesn't work
        // dispatch('jv/getRelated', 
        // `${personModel}/${person.id}/completed_surveys`

        // ).then((data) => {
        //   console.log(person.completed_surveys);
        //   console.log("i got data back", data)
        //   res(data);
        // }).catch(rej);

        // instead do something else that does work
        dispatch('jv/get', `/${personModel}/${person.id}/completed_surveys`).then((data) => {
            commit('jv/mergeRecords', {
              _jv: {
                id: person.id,
                type: personModel,
                relationships: {
                  completed_surveys: {
                    data: Object.keys(data).filter(id => id !== '_jv').map(id => ({type: "survey", id}))
                  }
                }
              }
            });
            res(data)

            // "doohickeys": {
            //   "data": [
            //     {
            //       "type": "doohickey",
            //       "id": "20"
            //     }
            //   ]
            // }
              // let {_jv, ...filteredMailings} = data;
              // let sortableMailings = Object.values(filteredMailings);
              // sortableMailings.sort((a, b) => DateTime.fromISO(b.date_sent) - DateTime.fromISO(a.date_sent));
              // this.fetchedMailings = sortableMailings
          }).catch(rej);
      })
    }
  },
  selected: {
    [personModel]: undefined
  },
  getters: {
  },
}
