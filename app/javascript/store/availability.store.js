import { NEW } from './model.store';

export const NEW_AVAILABILITY = 'NEW AVAILABILITY';

export const availabilityModel = 'availability';

export const availabilityEndpoints = {
  [availabilityModel]: 'availability'
}

export const availabilityStore = {
  actions: {
    [NEW_AVAILABILITY] ({dispatch}, attributes) {
      return dispatch(NEW, {model: availabilityModel, selected: false, ...attributes})
    },
  },
  selected: {
    [availabilityModel]: undefined
  },
  // Need to get availabilities for a person
  getters: {
  },
  mutations: {
  }
}
