<template>
  <b-navbar id="mobile-navbar" toggleable="sm" class="w-100 justify-content-start align-items-start" type="dark" variant="primary"
    :class="{'not-production': currentSettings.env !== 'production'}" :sticky="true"
  >
      <b-navbar-toggle target="nav-collapse" class="mr-2 mt-2"></b-navbar-toggle>
      <div class="d-flex flex-wrap justify-content-between align-items-center" style="flex-basis: calc(100% - 4rem)">
        <b-navbar-brand href="#" class="bigger">Planorama</b-navbar-brand>
        <b-nav-text v-if="loggedIn">Logged in as: {{ currentUserDisplay }}</b-nav-text>
      </div>


    <b-collapse id="nav-collapse" is-nav>
      <b-navbar-nav v-if="loggedIn" class="border-top mt-1">
        <side-nav-items></side-nav-items>
      </b-navbar-nav>
      <b-navbar-nav class="border-top mt-1">
        <help-link :mobile="true"></help-link>
        <b-nav-item href="https://planoramaevents.github.io/planorama" target="_blank" >
          <b-icon-info-circle class="mr-2"></b-icon-info-circle>About
        </b-nav-item>
        <b-nav-item v-if="loggedIn" @click="logout">
          <b-icon-door-open class="mr-2"></b-icon-door-open>Logout
        </b-nav-item>
      </b-navbar-nav>
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

.navbar.navbar-dark .border-top {
  border-color: rgba(255, 255, 255, 0.5) !important;
}

.navbar-brand.bigger {
  font-size: 2rem;
  font-weight: 500;
}
</style>
