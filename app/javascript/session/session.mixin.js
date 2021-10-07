import {mapState, mapActions } from 'vuex';
import { GET_SESSION_USER }  from "../store/session.store";

const sessionMixin = {
  computed: {
    // don't quite understand what this part is doing
    // map this.session to store.state.session
    // ...mapState(['session']),
    ...mapState({
      currentUser: 'user'
    }),
    loggedIn() {
      return !!this.currentUser.id
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
