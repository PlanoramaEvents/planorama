import {mapState, mapActions } from 'vuex';
import { toastMixin, modelMixin, personSessionMixin } from "@/mixins";
import { NEW_SESSION_ASSIGNMENT, SESSION_EXPRESS_INTEREST, SESSION_UNEXPRESS_INTEREST } from "../store/session_assignment.store";
import { SAVE, DELETE } from "../store/model.store";

import {
  SESSION_INTEREST_SUCCESS,
  SESSION_INTEREST_ERROR,
  SESSION_INTEREST_REMOVE_SUCCESS,
  SESSION_INTEREST_REMOVE_ERROR,
  SESSION_INTEREST_UPDATE_SUCCESS,
  SESSION_INTEREST_UPDATE_ERROR
} from '../constants/strings'

export const sessionAssignmentMixin = {
  mixins: [modelMixin, toastMixin, personSessionMixin],
  methods: {
    ...mapActions({
      newSessionAssignment: NEW_SESSION_ASSIGNMENT,
      sessionExpressInterest: SESSION_EXPRESS_INTEREST,
      sessionUnExpressInterest: SESSION_UNEXPRESS_INTEREST,
    }),
    expressInterest(session, success_text = SESSION_INTEREST_SUCCESS, error_text = SESSION_INTEREST_ERROR) {
      return this.toastPromise(
        this.sessionExpressInterest({session: session}),
        success_text,
        error_text
      );
    },
    removeInterest(assignment, success_text = SESSION_INTEREST_REMOVE_SUCCESS, error_text = SESSION_INTEREST_REMOVE_ERROR) {
      return this.toastPromise(
        this.sessionUnExpressInterest({assignment: assignment}),
        success_text,
        error_text
      );
    }
  }
}

export default sessionAssignmentMixin;
