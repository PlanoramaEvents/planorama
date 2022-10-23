// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
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

import 'vue-select/dist/vue-select.css';

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
import { configure as validationConfigure, extend as validationExtend} from 'vee-validate';
import { min, max, regex, required, numeric, digits, email } from 'vee-validate/dist/rules';

validationConfigure({
  classes: {
    valid: 'is-valid',
    invalid: 'is-invalid',
    dirty: 'is-dirty'
  }
})

validationExtend('min', min);
validationExtend('max', max);
validationExtend('regex', regex);
validationExtend('email', email);
validationExtend('numeric', numeric);
validationExtend('digits', digits);

validationExtend('required', {
  ...required,
  message: 'This field is required'
});

Vue.config.errorHandler = (err, vm, info) => {
  console.error(err);
  // set up in webpack
  if(NODE_ENV !== 'development' || (err?.response && err.response?.status !== 422)) {
    window.alert("Whoops! We messed up! Click ok to reload the page.")
    window.location.reload();
  }
}

Vue.use(BootstrapVue, {
  BSkeleton: { animation: 'fade' }
});
Vue.use(BootstrapVueIcons);
Vue.use(CustomIconsPlugin);
Vue.use(AsyncComputed);
Vue.use(CKEditor);
Vue.use(VuePluralize);

import vSelect from "vue-select";
Vue.component("v-select", vSelect);
import "vue-select/dist/vue-select.css";

Vue.filter('na_if_empty', function (value) {
  if (value === undefined) return 'Restricted'
  if (value === true) return "Yes"
  if (value === false) return "No"
  if (value === null || value.trim().length == 0) return 'Not Specified'
  return value
})

Vue.filter('capitalize', function (value) {
  if (value && value.length > 0) {
    return value.replace(/\w\S*/g, (w) => (w.replace(/^\w/, (c) => c.toUpperCase())))
  }
  return value
})

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
  },
})

document.addEventListener('DOMContentLoaded', () => {
  app.$mount('#app');
})
