import {mapState, mapActions } from 'vuex';
import { GET_SESSION_USER }  from "./session.store";

const sessionMixin = {
  computed: {
    ...mapState(['session']),
    ...mapState('session', {
      currentUser: 'user'
    }),
    loggedIn() {
      return !!this.currentUser.id
    }
  },
  methods: {
    ...mapActions('session', {
      fetchSession: GET_SESSION_USER
    })
  },
  mounted() {
    this.fetchSession();
  }
}

export default sessionMixin;
