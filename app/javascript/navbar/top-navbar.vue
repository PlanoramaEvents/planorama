<template>
  <div class="col-12 px-0">
    <b-navbar toggleable="lg" type="light" class="align-items-baseline">
      <b-navbar-brand to="/">Planorama</b-navbar-brand>
      <b-navbar-nav class="ml-auto">
        <b-nav-form>
          <help-link></help-link>
          <a href="https://chicagoworldcon.github.io/planorama" target="_blank" class="btn btn-link text-light my-2 my-sm-0 mx-2">About</a>
          <!-- TODO logout button -->
          <b-button v-if="loggedIn" @click="logout" variant="primary">Logout</b-button>
        </b-nav-form>
      </b-navbar-nav>
    </b-navbar>
    <!-- TODO fix toaster -->
    <b-toaster id="planotoast" name="planotoast"></b-toaster>
  </div>
</template>

<script>
import HelpLink from '../administration/help_link.vue';
import authMixin from '../auth.mixin';
import sessionMixin from '../session/session.mixin';

export default {
  name: 'TopNavbar',
  components: {
    HelpLink,
  },
  mixins: [
    authMixin,
    sessionMixin
  ],
  methods: {
    logout() {
      this.signOut().then(() => {
        window.location.href="/"
      })
    }
  }
}
</script>

<style>

</style>
