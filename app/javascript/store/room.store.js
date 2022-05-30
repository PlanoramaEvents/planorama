import { NEW } from './model.store';

export const NEW_ROOM = 'NEW ROOM';
export const SET_ROOMS_FOR_SCHEDULING = 'SET_ROOMS_FOR_SCHEDULING';

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
  state: {
    roomsForScheduling: []
  },
  selected: {
    [roomModel]: undefined
  },
  getters: {
    fetchedRooms(state, getters) {
      return Object.values(getters['jv/get']({_jv: { type: roomModel }}))
    }
  },
  mutations: {
    [SET_ROOMS_FOR_SCHEDULING] (state, rooms) {
      state.roomsForScheduling = rooms;
    }
  }
}
