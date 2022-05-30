import { NEW, PATCH_FIELDS } from './model.store';

export const NEW_PERSON = 'NEW PERSON';
export const PATCH_PERSON_MODEL = 'PATCH_PERSON_MODEL'

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
    }
  },
  selected: {
    [personModel]: undefined
  },
  getters: {
  },
}
