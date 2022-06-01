import { NEW } from './model.store';

export const NEW_ROOM = 'NEW ROOM';
export const SET_ROOMS_FOR_SCHEDULING = 'SET_ROOMS_FOR_SCHEDULING';
export const DUPLICATE_ROOM = 'DUPLICATE ROOM';

export const roomModel = 'room';

export const roomEndpoints = {
  [roomModel]: 'room'
}

export const roomStore = {
  actions: {
    [NEW_ROOM] ({dispatch}, attributes) {
      return dispatch(NEW, {model: roomModel, selected: false, ...attributes})
    },
    [DUPLICATE_ROOM] ({dispatch}, {item}) {
      let newRoom = {
        name: `Copy of ${item.name}`,
        floor: item['floor'],
        purpose: item.purpose,
        comment: item['comment'],
        open_for_schedule: item.open_for_schedule,
        is_virtual: item.is_virtual,
        length: item.length,
        width: item.width,
        height: item.height,
        linear_units: item.linear_units,
        area: item.area,
        area_units: item.area_units,
        capacity: item.capacity,
        room_set: item.room_set,
      }
      return dispatch(NEW, {model: roomModel, selected: true, ...newRoom})
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
