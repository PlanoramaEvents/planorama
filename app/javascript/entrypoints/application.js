// console.log('Visit the guide for more information: ', 'https://vite-ruby.netlify.app/guide/rails')

import { BootstrapVue, IconsPlugin, BootstrapVueIcons } from 'bootstrap-vue';
import Vue from 'vue';
import { createApp } from 'vue';
import VueCookies from 'vue-cookies'
import { router } from '@/app.router';
import { store } from '@/store/model.store';
import VueResizeText from "vue3-resize-text"

import { CustomIconsPlugin } from '../icons';
import AsyncComputed from 'vue-async-computed';
// TODO: will need to change at some point
import CKEditor from 'ckeditor4-vue/dist/ckeditor';
import VuePluralize from 'vue-pluralize';
// 
import { defineRule } from 'vee-validate';
import { min, max, regex, required, numeric, digits, email, integer } from '@vee-validate/rules';

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import vSelect from "vue-select";
Vue.component("v-select", vSelect);
import "vue-select/dist/vue-select.css";

import PlanoramaApp from '../app.vue';

Vue.use(BootstrapVue, {
  BSkeleton: { animation: 'fade' }
});

Vue.use(VueCookies, {
  // options here
});

// validationConfigure({
//   classes: {
//     valid: 'is-valid',
//     invalid: 'is-invalid',
//     dirty: 'is-dirty'
//   }
// })

defineRule('min', min);
defineRule('max', max);
defineRule('regex', regex);
defineRule('email', email);
defineRule('numeric', numeric);
defineRule('digits', digits);
defineRule('integer', integer);

// validationExtend('required', {
//   ...required,
//   message: 'This field is required'
// });


Vue.use(IconsPlugin)
Vue.use(BootstrapVueIcons)
Vue.use(CustomIconsPlugin);
Vue.use(AsyncComputed);
Vue.use(CKEditor);
Vue.use(VuePluralize);

const app = createApp(PlanoramaApp);

// See/review https://enterprisevue.dev/blog/error-handling-in-vue-3/
app.config.errorHandler = (err, vm, info) => {
  console.error("Error:", err);
  // console.error("Vue component:", vm);
  // console.error("Additional info:", info);
  if (!import.meta.env.DEV || (err?.response && err.response?.status !== 422)) {
    window.alert("Whoops! We messed up! Click ok to reload the page.")
    window.location.reload();
  }
};

// See https://v3-migration.vuejs.org/breaking-changes/filters
// Vue.filter('na_if_empty', function (value) {
//   if (value === undefined) return 'Restricted'
//   if (value === true) return "Yes"
//   if (value === false) return "No"
//   if (value === null || value.trim().length == 0) return 'Not Specified'
//   return value
// })

// Vue.filter('capitalize', function (value) {
//   if (value && value.length > 0) {
//     return value.replace(/\w\S*/g, (w) => (w.replace(/^\w/, (c) => c.toUpperCase())))
//   }
//   return value
// })


app.use(VueResizeText)
app.use(router)   // Set up the router
app.use(store)    // Set up the store

// app.use({
//   install() {
//     window._ = _;
//     app.config.globalProperties.window = window; // somehow this is needed?
//     app.config.globalProperties._ = _;
//   }
// });

app.mount('#app') // Display app using element with id 'app'
