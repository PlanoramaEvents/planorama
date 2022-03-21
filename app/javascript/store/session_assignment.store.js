import { NEW } from './model.store';
import personSessionMixin from "../auth/person_session.mixin";

export const NEW_SESSION_ASSIGNMENT = 'NEW SESSION ASSIGNMENT';

export const sessionAssignmentModel = 'session_assignment';

export const sessionAssignmentEndpoints = {
  [sessionAssignmentModel]: 'session_assignment'
}

export const sessionAssignmentStore = {
  actions: {
    [NEW_SESSION_ASSIGNMENT] ({dispatch}, {session, person_id}) {
      // TODO: change
      let newAssignment = {
        person_id: person_id,
        session_id: session.id,
        interested: true
      }
      return dispatch(NEW, {model: sessionAssignmentModel, selected: false, ...newAssignment});
    },
    // TODO: add a not interested action etc
  },
  selected: {
    [sessionAssignmentModel]: undefined
  },
  getters: {
  },
}
