import { NEW } from './model.store';

export const NEW_MAILING = 'NEW MAILING';

export const mailingModel = 'mailing';

export const mailingEndpoints = {
  [mailingModel]: 'mailing'
}

export const mailingStore = {
  // ??? state
  actions: {
    [NEW_MAILING] ({dispatch}, attributes) {
      return dispatch(NEW, {model: mailingModel, selected: false, ...attributes})
    },
  },
  selected: {
    [mailingModel]: undefined
  },
  getters: {
  },
}
