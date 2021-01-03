/* eslint no-console: 0 */
import Vue from 'vue/dist/vue.esm'
import Buefy from 'buefy'
import '../stylesheets/style.scss'
// import 'buefy/dist/buefy.css'

Vue.use(Buefy)

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
