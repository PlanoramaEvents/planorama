import { NEW } from './model.store';

export const NEW_PERSON = 'NEW PERSON';

export const personModel = 'person';

export const personEndpoints = {
  [personModel]: 'person'
}

export const personStore = {
  actions: {
    [NEW_PERSON] ({dispatch}, attributes) {
      return dispatch(NEW, {model: personModel, selected: false, ...attributes})
    },
  },
  selected: {
    [personModel]: undefined
  },
  getters: {
  },
}
