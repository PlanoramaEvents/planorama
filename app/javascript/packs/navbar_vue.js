/* eslint no-console: 0 */
// import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import App from '../app.vue'
import Buefy from 'buefy'
import 'buefy/dist/buefy.css'

Vue.use(Buefy)
// Vue.use(TurbolinksAdapter)

// document.addEventListener('turbolinks:load', () => {
document.addEventListener('DOMContentLoaded', () => {
  // const app = new Vue()
  // app.$mount('#top-navbar')
  const app = new Vue({
    el: '#top-navbar',
    data: () => {
      return {
        isActive: true,
        currentLocation: location.pathname
      }
    },
    components: { App }
  })
})
