import { NEW } from './model.store';

export const NEW_ROOMSET = 'NEW ROOMSET';

export const roomSetModel = 'room_set';

export const roomSetEndpoints = {
  [roomSetModel]: 'room_set'
}

export const roomSetStore = {
  actions: {
    [NEW_ROOMSET] ({dispatch}, attributes) {
      return dispatch(NEW, {model: roomSetModel, selected: false, ...attributes})
    },
  },
  selected: {
    [roomSetModel]: undefined
  },
  getters: {
  },
}
