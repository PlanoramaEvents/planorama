import {http} from "@/http"

import { NEW } from './model.store';
import personSessionMixin from "../auth/person_session.mixin";

export const NEW_SESSION_ASSIGNMENT = 'NEW SESSION ASSIGNMENT';

export const SESSION_EXPRESS_INTEREST = 'SESSION EXPRESS INTEREST';
export const SESSION_UNEXPRESS_INTEREST = 'SESSION UNEXPRESS INTEREST';

export const sessionAssignmentModel = 'session_assignment';

export const sessionAssignmentEndpoints = {
  [sessionAssignmentModel]: 'session_assignment'
}

export const sessionAssignmentStore = {
  actions: {
    [NEW_SESSION_ASSIGNMENT] ({dispatch}, {session, person_id}) {
      let newAssignment = {
        person_id: person_id,
        session_id: session.id,
        interested: true
      }
      return dispatch(NEW, {model: sessionAssignmentModel, selected: false, ...newAssignment});
    },
    [SESSION_EXPRESS_INTEREST] ({dispatch}, {session}) {
      let url = `/session/${session.id}/express_interest`
      let data = { _jv: { type: 'session_assignment' } }

      return new Promise((res, rej) => {
        dispatch('jv/get', [data, {url: url}]).then((assignment) => {
          res(assignment);
        }).catch(rej)
      });
    },
    [SESSION_UNEXPRESS_INTEREST] ({dispatch}, {assignment}) {
      let url = `/session_assignment/${assignment.id}/unexpress_interest`
      let data = { _jv: { type: 'session_assignment' } }

      return new Promise((res, rej) => {
        dispatch('jv/get', [data, {url: url}]).then((assignment) => {
          res(assignment);
        }).catch(rej)
      });
    }
  },
  selected: {
    [sessionAssignmentModel]: undefined
  },
  getters: {
  },
}
