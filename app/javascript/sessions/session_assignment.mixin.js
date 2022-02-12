import {mapState, mapActions } from 'vuex';
import { toastMixin, modelMixin, personSessionMixin } from "@/mixins";
import { NEW_SESSION_ASSIGNMENT } from "../store/session_assignment.store";
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
    ...mapActions({ newSessionAssignment: NEW_SESSION_ASSIGNMENT}),
    expressInterest(session, person = null, success_text = SESSION_INTEREST_SUCCESS, error_text = SESSION_INTEREST_ERROR) {
      if (!person) {
        person = this.currentUser;
      }
      return this.toastPromise(
        this.newSessionAssignment({session: session, person_id: person.id }), success_text, error_text
      );
    },
    removeInterest(assignment, success_text = SESSION_INTEREST_REMOVE_SUCCESS, error_text = SESSION_INTEREST_REMOVE_ERROR) {
      return this.toastPromise(
        this.$store.dispatch(
          DELETE, {model: this.model, itemOrId: assignment}
        ),
        success_text, error_text
      );
    }
  }
}

export default sessionAssignmentMixin;
