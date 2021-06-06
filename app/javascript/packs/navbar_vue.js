/* eslint no-console: 0 */
import Vue from 'vue'
import { NavbarPlugin } from 'bootstrap-vue'

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
  const app2 = new Vue({
    el: '#side-navbar',
    data: () => {
      return {
        isActive: true,
        currentLocation: location.pathname
      }
    }
  })
})
