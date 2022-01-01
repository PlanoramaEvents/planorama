// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
// require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
// TODO do we need this twice?
require("jquery") // Optional, pulling this in for Bootstrap 4

// import "@fortawesome/fontawesome-free/js/all";
import 'jquery';
import 'popper.js';
// TODO do we need this twice
import 'bootstrap';
import 'bootstrap/dist/js/bootstrap';

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

import '../stylesheets/custom.scss'
import '../stylesheets/style.scss'

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

import Vue from 'vue';
import {BootstrapVue, BootstrapVueIcons } from 'bootstrap-vue';
import { CustomIconsPlugin } from '../icons';
import AsyncComputed from 'vue-async-computed';
import CKEditor from 'ckeditor4-vue';
import VuePluralize from 'vue-pluralize';

Vue.use(BootstrapVue);
Vue.use(BootstrapVueIcons);
Vue.use(CustomIconsPlugin);
Vue.use(AsyncComputed);
Vue.use(CKEditor);
Vue.use(VuePluralize);

import PlanoramaApp from '../app.vue';
import { router } from '../app.router';
import { store } from '../store/model.store';

const app = new Vue({
  components: { PlanoramaApp },
  router,
  store,
  mounted() {
    // console.debug('*** APP X MOUNTED')
    // console.debug('****** ST ', store)
  }
})

document.addEventListener('DOMContentLoaded', () => {
  app.$mount('#app');
})
