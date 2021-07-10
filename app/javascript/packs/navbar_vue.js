/* eslint no-console: 0 */
import Vue from 'vue'
import { NavbarPlugin, BootstrapVue, BootstrapVueIcons } from 'bootstrap-vue'

import HelpLink from '../administration/help_link.vue';
import TermsOfUseLink from '../administration/terms_of_use_link.vue';
import PrivacyPolicyLink from '../administration/privacy_policy_link.vue';

Vue.use(NavbarPlugin)
Vue.use(BootstrapVue)
Vue.use(BootstrapVueIcons)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#top-navbar',
    data: () => {
      return {
        isActive: true,
        currentLocation: location.pathname
      }
    },
    components: {
      HelpLink,
    }
  })
  const app2 = new Vue({
    el: '#side-navbar',
    data: () => {
      return {
        isActive: true,
        currentLocation: location.pathname
      }
    },
  })
  const app3 = new Vue({
    el: '#bottom-navbar',
    components: {
      PrivacyPolicyLink,
      TermsOfUseLink
    }
  })
})
