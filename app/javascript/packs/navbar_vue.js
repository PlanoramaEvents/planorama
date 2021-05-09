/* eslint no-console: 0 */
import Vue from 'vue'
import { NavbarPlugin } from 'bootstrap-vue'

Vue.use(NavbarPlugin)

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#top-navbar',
    data: () => {
      console.debug('navbar ', location.pathname)
      return {
        isActive: true,
        currentLocation: location.pathname
      }
    }
  })
})
