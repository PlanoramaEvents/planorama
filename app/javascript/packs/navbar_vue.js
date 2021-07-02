/* eslint no-console: 0 */
import Vue from 'vue'
import { NavbarPlugin, BootstrapVue } from 'bootstrap-vue'

import HelpLink from '../administration/help_link.vue';

Vue.use(NavbarPlugin)
Vue.use(BootstrapVue)

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
})
