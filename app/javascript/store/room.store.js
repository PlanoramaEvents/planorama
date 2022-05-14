import { NEW } from './model.store';

export const NEW_ROOM = 'NEW ROOM';

export const roomModel = 'room';

export const roomEndpoints = {
  [roomModel]: 'room'
}

export const roomStore = {
  actions: {
    [NEW_ROOM] ({dispatch}, attributes) {
      return dispatch(NEW, {model: roomModel, selected: false, ...attributes})
    },
  },
  selected: {
    [roomModel]: undefined
  },
  getters: {
  },
}
