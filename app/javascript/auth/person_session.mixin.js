import {mapState, mapActions } from 'vuex';
import { GET_ROLE_BASED_ACCESS_CONTROL, GET_SESSION_USER }  from "../store/person_session.store";

export const personSessionMixin = {
  computed: {
    ...mapState({
      currentUser: 'user',
      rbac: 'rbac',
    }),
    loggedIn() {
      return !!this.currentUser.id
    },
    hasPassword() {
      return !!this.currentUser.has_password
    },
    currentUserIsAdmin() {
      return !!Object.values(this.currentUser.convention_roles).find(r => r.role === "admin")
    },
    currentUserIsStaff() {
      return !!Object.values(this.currentUser.convention_roles).find(r => r.role === "staff")
    },
    currentUserIsParticipant() {
      return !!Object.values(this.currentUser.convention_roles).find(r => r.role === "participant")
    }
  },
  methods: {
    ...mapActions({
      fetchSession: GET_SESSION_USER,
      fetchRbac: GET_ROLE_BASED_ACCESS_CONTROL,
    }),
    // Each item in the rbac JSON will be called a 'subject'
    canCreate(subject) {
      return this.rbac[subject]?.create
    },
    canDestroy(subject) {
      return this.rbac[subject]?.destroy
    },
    canIndex(subject) {
      return this.rbac[subject]?.edit
    },
    canShow(subject) {
      return this.rbac[subject]?.edit
    },
    canUpdate(subject) {
      return this.rbac[subject]?.edit
    },
  },
  mounted() {
    // fetch the current session on mount !!!
    this.fetchSession();
    this.fetchRbac();
  }
}

export default personSessionMixin;
