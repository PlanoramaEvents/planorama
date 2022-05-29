<template>
  <div class="col-12 px-0">
    <b-navbar toggleable="lg" type="light" class="justify-content-between">
      <b-navbar-brand to="/">Planorama</b-navbar-brand>
      <div class="d-flex flex-column h-100">
        <div class="text-light mb-2">Logged in as: {{currentUser.primary_email.email}}</div>
        <b-navbar-nav class="ml-auto">
          <b-nav-form>
            <help-link></help-link>
            <a href="https://chicagoworldcon.github.io/planorama" target="_blank" class="btn btn-link text-light my-2 my-sm-0 mx-2">About</a>
            <!-- TODO logout button -->
            <b-button v-if="loggedIn" @click="logout" variant="primary">Logout</b-button>
          </b-nav-form>
        </b-navbar-nav>
      </div>
    </b-navbar>
    <!-- TODO fix toaster -->
    <b-toaster id="planotoast" name="planotoast"></b-toaster>
  </div>
</template>

<script>
import HelpLink from '../administration/help_link.vue';
import authMixin from '../auth/auth.mixin';
import personSessionMixin from '../auth/person_session.mixin';

export default {
  name: 'TopNavbar',
  components: {
    HelpLink,
  },
  mixins: [
    authMixin,
    personSessionMixin
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
