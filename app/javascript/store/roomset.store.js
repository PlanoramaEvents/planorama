import { NEW } from './model.store';

export const NEW_ROOMSET = 'NEW ROOMSET';

export const roomsetModel = 'roomset';

export const roomsetEndpoints = {
  [roomsetModel]: 'roomset'
}

export const roomsetStore = {
  actions: {
    [NEW_ROOMSET] ({dispatch}, attributes) {
      return dispatch(NEW, {model: roomsetModel, selected: false, ...attributes})
    },
  },
  selected: {
    [roomsetModel]: undefined
  },
  getters: {
  },
}
