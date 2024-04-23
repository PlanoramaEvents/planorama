<template>
  <div class="col-12 px-0">
    <b-navbar toggleable="lg" type="light" :class="['justify-content-between', {'not-production': currentSettings.env !== 'production'}]">
      <b-navbar-brand to="/" :class="{ 'text-warning': currentSettings.env !== 'production'}">Planorama<span v-if="currentSettings.env !== 'production'" class="h1"> - {{currentSettings.env}}</span></b-navbar-brand>
      <div class="d-flex flex-column h-100">
        <!-- TODO -->
        <div class="text-light mb-2">Zalogowany jako: {{ currentUserDisplay }}</div>
        <b-navbar-nav class="ml-auto">
          <b-nav-form>
            <help-link></help-link>
            <a href="https://planoramaevents.github.io/planorama" target="_blank" class="btn btn-link text-light my-2 my-sm-0 mx-2">O Planoramie (ENG)</a>
            <b-button v-if="loggedIn" @click="logout" variant="primary">Wyloguj</b-button>
          </b-nav-form>
        </b-navbar-nav>
      </div>
    </b-navbar>
    <!-- TODO fix toaster -->
    <b-toaster id="planotoast" name="planotoast"></b-toaster>
  </div>
</template>

<script>
import { settingsMixin } from '@/mixins';
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
    personSessionMixin,
    settingsMixin
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
