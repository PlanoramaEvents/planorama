import { NEW } from './model.store';

export const NEW_AGREEMENT = 'NEW AGREEMENT';

export const agreementModel = 'agreement';

export const agreementEndpoints = {
  [agreementModel]: 'agreement'
}

export const agreementStore = {
  actions: {
    [NEW_AGREEMENT] ({dispatch}, attributes) {
      return dispatch(NEW, {model: agreementModel, selected: false, ...attributes})
    },
  },
  selected: {
    [agreementModel]: undefined
  },
  getters: {
  },
}
