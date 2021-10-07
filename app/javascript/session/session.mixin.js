import {mapState, mapActions } from 'vuex';
// TODO
import { GET_SESSION_USER }  from "../store/model.store";

const sessionMixin = {
  // TODO: these mappins are not quite correct
  computed: {
    // map this.session to store.state.session
    ...mapState(['session']),
    ...mapState('session', {
      currentUser: 'user'
    }),
    loggedIn() {
      console.debug('****** ST ', this.$store)
      // return !!this.currentUser.id
      false
    }
  },
  methods: {
    ...mapActions('session', {
      fetchSession: GET_SESSION_USER
    })
  },
  mounted() {
    // fetch the current session on mount !!!
    this.fetchSession();
  }
}

export default sessionMixin;
