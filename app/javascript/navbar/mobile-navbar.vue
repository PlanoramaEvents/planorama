<template>
  <b-navbar id="mobile-navbar" toggleable="sm" class="w-100" type="dark" variant="primary"
    :class="{'not-production': currentSettings.env !== 'production'}"
  >
    <b-navbar-brand href="#">Planorama</b-navbar-brand>
    <b-nav-text>Logged in as: {{ currentUserDisplay }}</b-nav-text>

    <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>

    <b-collapse id="nav-collapse" is-nav>
        <side-nav-items></side-nav-items>
        <help-link></help-link>
        <div><a href="https://planoramaevents.github.io/planorama" target="_blank" class="btn btn-link text-light">About</a></div>
        <div><b-button v-if="loggedIn" @click="logout" variant="info">Logout</b-button></div>
    </b-collapse>
  </b-navbar>
</template>

<script>
import { settingsMixin, personSessionMixin } from '@/mixins'
import SideNavItems from './side-nav-items.vue';
import HelpLink from '@/administration/help_link.vue';
import authMixin from '@/auth/auth.mixin';

export default {
  name: "MobileNavbar",
  mixins: [
    settingsMixin,
    personSessionMixin,
    authMixin,
  ],
  components: {
    SideNavItems,
    HelpLink,
  },
  methods: {
    logout() {
      this.signOut().then(() => {
        window.location.href="/"
      })
    }
  }
}
</script>

<style lang="scss" scoped>
@media (min-width: 576px) {
  #mobile-navbar {
    display: none !important;
  }
}
</style>
