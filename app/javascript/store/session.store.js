import { NEW } from './model.store';

export const NEW_SESSION = 'NEW SESSION';

export const sessionModel = 'session';

export const sessionEndpoints = {
  [sessionModel]: 'session'
}

export const sessionStore = {
  actions: {
    [NEW_SESSION] ({dispatch}, attributes) {
      return dispatch(NEW, {model: sessionModel, selected: false, ...attributes})
    },
  },
  selected: {
    [sessionModel]: undefined
  },
  getters: {
  },
}
