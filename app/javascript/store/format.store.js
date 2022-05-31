import { NEW } from './model.store';

export const NEW_FORMAT = 'NEW FORMAT';

export const formatModel = 'format';

export const formatEndpoints = {
  [formatModel]: 'format'
}

export const formatStore = {
  actions: {
    [NEW_FORMAT] ({dispatch}, attributes) {
      return dispatch(NEW, {model: formatModel, selected: false, ...attributes})
    },
  },
  selected: {
    [formatModel]: undefined
  },
  getters: {
  },
}
