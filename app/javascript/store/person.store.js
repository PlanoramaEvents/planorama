import { NEW, PATCH_FIELDS, SELECT } from './model.store';
import { GET_SESSION_USER } from './person_session.store';

export const NEW_PERSON = 'NEW PERSON';
export const PATCH_PERSON_MODEL = 'PATCH_PERSON_MODEL';
export const UNLINK_PERSON = 'UNLINK PERSON';

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
    [UNLINK_PERSON] ({dispatch, commit}, {person}) {
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
          // person should always be selected at this point so we shouldn't check, we should just select.
          commit(SELECT, {model, itemOrId: savedModel});
          dispatch(GET_SESSION_USER, {force: true}).then(() => {
            res(savedModel);
          });
        }).catch(rej);
      });
    }
  },
  selected: {
    [personModel]: undefined
  },
  getters: {
  },
}
