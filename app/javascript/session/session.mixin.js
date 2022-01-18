import {mapState, mapActions } from 'vuex';
import { GET_SESSION_USER }  from "../store/session.store";

export const sessionMixin = {
  computed: {
    ...mapState({
      currentUser: 'user'
    }),
    loggedIn() {
      return !!this.currentUser.id
    },
    currentUserIsAdmin() {
      return !!Object.values(this.currentUser.person_roles).find(r => r.role === "admin")
    }
  },
  methods: {
    ...mapActions({
      fetchSession: GET_SESSION_USER
    })
  },
  mounted() {
    // fetch the current session on mount !!!
    this.fetchSession();
  }
}

export default sessionMixin;
