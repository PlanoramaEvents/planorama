/* eslint no-console: 0 */
import Vue from 'vue/dist/vue.esm'
// import '../stylesheets/style.scss'

import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'


import { NavbarPlugin } from 'bootstrap-vue'

Vue.use(BootstrapVue)

// Optionally install the BootstrapVue icon components plugin
// Vue.use(IconsPlugin)

Vue.use(NavbarPlugin)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#top-navbar',
    data: () => {
      return {
        isActive: true,
        currentLocation: location.pathname
      }
    }
  })
})
