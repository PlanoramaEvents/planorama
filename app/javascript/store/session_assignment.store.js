import { NEW } from './model.store';

export const NEW_SESSION_ASSIGNMENT = 'NEW SESSION ASSIGNMENT';

export const sessionAssignmentModel = 'session_assignment';

export const sessionAssignmentEndpoints = {
  [sessionAssignmentModel]: 'session_assignment'
}

export const sessionAssignmentStore = {
  actions: {
    [NEW_SESSION_ASSIGNMENT] ({dispatch}, attributes) {
      return dispatch(NEW, {model: sessionAssignmentModel, selected: false, ...attributes})
    },
  },
  selected: {
    [sessionAssignmentModel]: undefined
  },
  getters: {
  },
}
