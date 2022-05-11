import { NEW } from './model.store';

export const NEW_VENUE = 'NEW VENUE';

export const venueModel = 'venue';

export const venueEndpoints = {
  [venueModel]: 'venue'
}

export const venueStore = {
  actions: {
    [NEW_VENUE] ({dispatch}, attributes) {
      return dispatch(NEW, {model: venueModel, selected: false, ...attributes})
    },
  },
  selected: {
    [venueModel]: undefined
  },
  getters: {
  },
}
